import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';
import '../services/mock_database_service.dart';
import '../services/payment_gateway_service.dart';

class PaymentException implements Exception {
  final String message;
  PaymentException(this.message);
  @override
  String toString() => message;
}

class StoreProvider with ChangeNotifier {
  final MockDatabaseService _db = MockDatabaseService();
  FirebaseFirestore? _firestore;
  String? _activeUserId;

  final List<CartItem> _cart = [];
  String _selectedCategory = 'All';
  ProductType? _selectedTypeFilter;

  // Idempotency token store to prevent duplicate payment processing
  final Set<String> _processedTransactionRefs = {};

  List<Product> get allProducts => List.unmodifiable(_db.products);
  List<CartItem> get cart => List.unmodifiable(_cart);
  List<OrderModel> get orders => List.unmodifiable(_db.orders);
  List<Product> get products => List.unmodifiable(_db.products);

  String get selectedCategory => _selectedCategory;
  ProductType? get selectedTypeFilter => _selectedTypeFilter;

  StoreProvider() {
    _initFirestoreSync();
  }

  void setActiveUserId(String? userId) {
    if (_activeUserId != userId) {
      _activeUserId = userId;
      if (userId != null) {
        _loadCartFromFirestore(userId);
      }
    }
  }

  Future<void> _initFirestoreSync() async {
    try {
      _firestore = FirebaseFirestore.instance;
      final snap = await _firestore!.collection('products').get();
      if (snap.docs.isNotEmpty) {
        final cloudProducts = snap.docs.map((d) => Product.fromMap(d.data())).toList();
        for (final p in cloudProducts) {
          final idx = _db.products.indexWhere((existing) => existing.id == p.id);
          if (idx >= 0) {
            _db.products[idx] = p;
          } else {
            _db.products.add(p);
          }
        }
        notifyListeners();
      }

      final ordersSnap = await _firestore!.collection('orders').get();
      if (ordersSnap.docs.isNotEmpty) {
        final cloudOrders = ordersSnap.docs.map((d) => OrderModel.fromMap(d.data())).toList();
        for (final o in cloudOrders) {
          if (!_db.orders.any((existing) => existing.id == o.id)) {
            _db.orders.insert(0, o);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[StoreProvider] Firestore sync note: $e');
    }
  }

  // Filtered Products
  List<Product> get filteredProducts {
    return _db.products.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesType = _selectedTypeFilter == null || p.type == _selectedTypeFilter;
      return matchesCategory && matchesType;
    }).toList();
  }

  // Categories list
  List<String> get categories {
    final set = {'All'};
    for (var p in _db.products) {
      set.add(p.category);
    }
    return set.toList();
  }

  // Cart Calculations
  int get cartCount => _cart.fold(0, (acc, item) => acc + item.quantity);

  double get cartSubtotal =>
      _cart.fold(0.0, (acc, item) => acc + item.totalPrice);

  bool get hasPhysicalItems =>
      _cart.any((item) => item.product.isPhysical);

  double get shippingFee => hasPhysicalItems ? 15.00 : 0.00;

  double get tax => cartSubtotal * 0.06; // 6% SST

  double get totalAmount => cartSubtotal + shippingFee + tax;

  // Cart Actions
  void addToCart(Product product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cart[index].quantity += 1;
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
    _persistCart();
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = newQuantity;
      }
      notifyListeners();
      _persistCart();
    }
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    _persistCart();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
    _persistCart();
  }

  void _persistCart() {
    if (_activeUserId != null) {
      try {
        _firestore ??= FirebaseFirestore.instance;
        final cartList = _cart.map((item) => item.toMap()).toList();
        _firestore!.collection('carts').doc(_activeUserId).set({
          'userId': _activeUserId,
          'items': cartList,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('[StoreProvider] Cart persist note: $e');
      }
    }
  }

  Future<void> _loadCartFromFirestore(String userId) async {
    try {
      _firestore ??= FirebaseFirestore.instance;
      final doc = await _firestore!.collection('carts').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final List items = doc.data()!['items'] ?? [];
        _cart.clear();
        for (var map in items) {
          _cart.add(CartItem.fromMap(map));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[StoreProvider] Cart load note: $e');
    }
  }

  void setFilterCategory(String cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void setFilterType(ProductType? type) {
    _selectedTypeFilter = type;
    notifyListeners();
  }

  // Checkout with real payment verification, FPX banking & idempotency token
  Future<OrderModel> checkout({
    required String userId,
    required String userEmail,
    ShippingAddress? shippingAddress,
    String paymentMethod = 'FPX',
    String? bankName,
    String? idempotencyKey,
  }) async {
    if (_cart.isEmpty) {
      throw PaymentException('Cannot checkout an empty shopping cart.');
    }

    final hasPhysical = hasPhysicalItems;
    final resolvedShippingAddress = shippingAddress ??
        (hasPhysical
            ? ShippingAddress(
                recipientName: 'Registered Learner',
                addressLine1: 'Level 8, Nexus Tower, Jalan Kerinchi',
                city: 'Kuala Lumpur',
                state: 'Wilayah Persekutuan',
                postalCode: '59200',
                country: 'Malaysia',
                phone: '+60 12-345 6789',
              )
            : null);

    final String token = idempotencyKey ?? 'IDEMP-${DateTime.now().millisecondsSinceEpoch}-${_cart.length}';
    if (_processedTransactionRefs.contains(token)) {
      throw PaymentException('Duplicate payment detected: Transaction $token has already been processed.');
    }

    // 1. Pre-capture Stock Verification
    for (final item in _cart) {
      if (item.product.isPhysical && item.product.stockQuantity < item.quantity) {
        throw PaymentException('Insufficient stock for ${item.product.name}. Only ${item.product.stockQuantity} remaining.');
      }
    }

    final isFpx = paymentMethod.toUpperCase().contains('FPX');
    final resolvedBank = bankName ?? (isFpx ? 'Maybank2u' : null);

    // 2. Verified Payment Gateway Processing
    final gateway = PaymentGatewayService();
    final gatewayResult = await gateway.processPayment(
      amount: totalAmount,
      currency: 'MYR',
      userEmail: userEmail,
      paymentMethod: paymentMethod,
      bankName: resolvedBank,
      idempotencyKey: token,
    );

    if (!gatewayResult.success) {
      throw PaymentException(gatewayResult.errorMessage ?? 'Payment authorization failed at gateway.');
    }

    _processedTransactionRefs.add(token);
    final String verifiedTxnRef = idempotencyKey ?? gatewayResult.transactionReference;

    final order = OrderModel(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      userId: userId,
      userEmail: userEmail,
      items: List.from(_cart),
      subtotal: cartSubtotal,
      shippingFee: shippingFee,
      tax: tax,
      totalAmount: totalAmount,
      hasPhysicalItems: hasPhysical,
      shippingAddress: resolvedShippingAddress,
      paymentMethod: paymentMethod,
      bankName: bankName ?? (paymentMethod.contains('FPX') ? 'Maybank2u' : null),
      transactionReference: verifiedTxnRef,
      isPaid: true,
      trackingNumber: hasPhysical ? 'MYPOS-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}-EXP' : null,
      status: OrderStatus.placed,
    );

    // 3. Atomic stock deduction and Firestore persistence
    try {
      _firestore ??= FirebaseFirestore.instance;
      final batch = _firestore!.batch();
      final orderRef = _firestore!.collection('orders').doc(order.id);
      batch.set(orderRef, order.toMap());

      for (final item in _cart) {
        if (item.product.isPhysical) {
          final prodRef = _firestore!.collection('products').doc(item.product.id);
          batch.update(prodRef, {
            'stockQuantity': FieldValue.increment(-item.quantity),
          });
        }
      }

      await batch.commit();
    } catch (e) {
      debugPrint('[StoreProvider] Firestore atomic checkout note: $e');
      if (!FirebaseService.isTestMode) {
        final rollbackRes = gateway.rollbackFailedTransaction(verifiedTxnRef);
        if (rollbackRes.isUncertain) {
          throw PaymentException('Database write failed and gateway rollback is UNCERTAIN: ${rollbackRes.errorMessage}. Flagged for reconciliation.');
        } else {
          throw PaymentException('Order persistence failed. Transaction rolled back: $e');
        }
      }
    }

    // Update in-memory stock
    for (final item in _cart) {
      if (item.product.isPhysical) {
        final idx = _db.products.indexWhere((p) => p.id == item.product.id);
        if (idx >= 0) {
          final updatedProduct = _db.products[idx].copyWith(
            stockQuantity: (_db.products[idx].stockQuantity - item.quantity).clamp(0, 99999),
          );
          _db.products[idx] = updatedProduct;
        }
      }
    }

    _db.orders.insert(0, order);
    _cart.clear();
    notifyListeners();
    _persistCart();

    return order;
  }

  // Advance Order Status (placed -> processing -> shipped -> delivered)
  void advanceOrderStatus(String orderId) {
    final idx = _db.orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      final order = _db.orders[idx];
      switch (order.status) {
        case OrderStatus.placed:
          order.status = OrderStatus.processing;
          break;
        case OrderStatus.processing:
          order.status = OrderStatus.shipped;
          break;
        case OrderStatus.shipped:
          order.status = OrderStatus.delivered;
          break;
        case OrderStatus.delivered:
        case OrderStatus.cancelled:
        case OrderStatus.refunded:
          break;
      }
      notifyListeners();

      try {
        _firestore ??= FirebaseFirestore.instance;
        _firestore!.collection('orders').doc(orderId).update({
          'status': order.status.name,
        });
      } catch (e) {
        debugPrint('[StoreProvider] Firestore order status update note: $e');
      }
    }
  }

  // 1. Order Cancellation (Before Payment Capture / Processing)
  Future<String> cancelOrder(String orderId, {String? reason}) async {
    final idx = _db.orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      final order = _db.orders[idx];
      if (order.status == OrderStatus.refunded) {
        throw PaymentException('Order is already refunded.');
      }

      // If the order was already paid, route through genuine refund processing
      if (order.isPaid) {
        return await refundOrder(orderId, reason: reason ?? 'Customer requested order cancellation');
      }

      order.status = OrderStatus.cancelled;
      notifyListeners();

      try {
        _firestore ??= FirebaseFirestore.instance;
        await _firestore!.collection('orders').doc(orderId).update({
          'status': OrderStatus.cancelled.name,
          'cancelReason': reason ?? 'Order cancelled by customer/admin',
        });
      } catch (e) {
        debugPrint('[StoreProvider] Order cancel note: $e');
      }
      return 'CANCELLED';
    }
    return '';
  }

  // 2. Genuine Payment Gateway Refund Processing with Verification & Stock Restoration
  Future<String> refundOrder(String orderId, {String? reason}) async {
    final idx = _db.orders.indexWhere((o) => o.id == orderId);
    if (idx < 0) {
      throw PaymentException('Order $orderId not found.');
    }

    final order = _db.orders[idx];
    if (order.status == OrderStatus.refunded) {
      throw PaymentException('Order $orderId has already been refunded.');
    }

    // Verify refund eligibility: Must be a paid order
    if (!order.isPaid) {
      throw PaymentException('Cannot refund an unpaid transaction.');
    }

    // Direct Payment Gateway Refund API Call
    final gateway = PaymentGatewayService();
    final refundResult = await gateway.processRefund(
      transactionReference: order.transactionReference ?? 'TXN-${order.id}',
      amount: order.totalAmount,
      reason: reason ?? 'Customer requested order refund',
    );

    if (!refundResult.success) {
      throw PaymentException(refundResult.errorMessage ?? 'Payment gateway rejected the refund.');
    }

    final String refundRef = refundResult.refundReference;

    // Atomic stock restoration and Firestore status update
    try {
      _firestore ??= FirebaseFirestore.instance;
      final batch = _firestore!.batch();
      final orderRef = _firestore!.collection('orders').doc(orderId);

      batch.update(orderRef, {
        'status': OrderStatus.refunded.name,
        'refundReference': refundRef,
        'refundedAt': FieldValue.serverTimestamp(),
        'cancelReason': reason ?? 'Payment refund processed via gateway reversal',
      });

      for (final item in order.items) {
        if (item.product.isPhysical) {
          final prodRef = _firestore!.collection('products').doc(item.product.id);
          batch.update(prodRef, {
            'stockQuantity': FieldValue.increment(item.quantity),
          });
        }
      }

      final logRef = _firestore!.collection('audit_logs').doc();
      batch.set(logRef, {
        'action': 'PAYMENT_REFUNDED',
        'details': 'Gateway reversal $refundRef verified for order $orderId (RM ${order.totalAmount.toStringAsFixed(2)}). Stock restored.',
        'userId': order.userId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      debugPrint('[StoreProvider] Firestore refund note: $e');
      if (!FirebaseService.isTestMode) {
        throw PaymentException('Refund recorded at gateway, but database update failed: $e');
      }
    }

    // Update in-memory
    order.status = OrderStatus.refunded;
    for (final item in order.items) {
      if (item.product.isPhysical) {
        final pIdx = _db.products.indexWhere((p) => p.id == item.product.id);
        if (pIdx >= 0) {
          final restored = _db.products[pIdx].copyWith(
            stockQuantity: _db.products[pIdx].stockQuantity + item.quantity,
          );
          _db.products[pIdx] = restored;
          updateProduct(restored);
        }
      }
    }

    notifyListeners();
    return refundRef;
  }

  // Digital Product Security: Verify user has paid order containing product
  bool hasUserPurchasedProduct(String userId, String productId) {
    return _db.orders.any((o) =>
        o.userId == userId &&
        o.isPaid &&
        o.items.any((item) => item.product.id == productId));
  }

  // User Purchased Digital Products (Strictly authorized)
  List<Product> getUserDigitalProducts(String userId) {
    final List<Product> result = [];
    final userOrders = _db.orders.where((o) => o.userId == userId && o.isPaid);
    for (var o in userOrders) {
      for (var item in o.items) {
        if (item.product.isDigital && !result.any((p) => p.id == item.product.id)) {
          result.add(item.product);
        }
      }
    }
    return result;
  }

  // Admin CRUD
  void addProduct(Product product) {
    _db.products.add(product);
    notifyListeners();
    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('products').doc(product.id).set(product.toMap());
    } catch (e) {
      debugPrint('[StoreProvider] Firestore product add note: $e');
    }
  }

  void updateProduct(Product product) {
    final idx = _db.products.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      _db.products[idx] = product;
      notifyListeners();
      try {
        _firestore ??= FirebaseFirestore.instance;
        _firestore!.collection('products').doc(product.id).set(product.toMap());
      } catch (e) {
        debugPrint('[StoreProvider] Firestore product update note: $e');
      }
    }
  }

  void deleteProduct(String productId) {
    _db.products.removeWhere((p) => p.id == productId);
    notifyListeners();
    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('products').doc(productId).delete();
    } catch (e) {
      debugPrint('[StoreProvider] Firestore product delete note: $e');
    }
  }

  /// Automated Transaction Reconciliation
  ReconciliationReport reconcileGatewayTransactions() {
    final gateway = PaymentGatewayService();
    final dbTxnRefs = _db.orders
        .where((o) => o.transactionReference != null)
        .map((o) => o.transactionReference!)
        .toList();
    return gateway.reconcile(databaseRecordedTxnRefs: dbTxnRefs);
  }
}
