import 'cart_model.dart';

enum OrderStatus {
  placed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

extension OrderStatusExtension on OrderStatus {
  String get displayName {
    switch (this) {
      case OrderStatus.placed:
        return 'Order Placed (Payment Verified)';
      case OrderStatus.processing:
        return 'Processing & Preparing';
      case OrderStatus.shipped:
        return 'Shipped / In Transit';
      case OrderStatus.delivered:
        return 'Delivered Successfully';
      case OrderStatus.cancelled:
        return 'Order Cancelled';
      case OrderStatus.refunded:
        return 'Payment Refunded';
    }
  }

  int get stepIndex {
    switch (this) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.processing:
        return 1;
      case OrderStatus.shipped:
        return 2;
      case OrderStatus.delivered:
        return 3;
      case OrderStatus.cancelled:
      case OrderStatus.refunded:
        return -1;
    }
  }
}

class ShippingAddress {
  final String recipientName;
  final String addressLine1;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String phone;

  ShippingAddress({
    required this.recipientName,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.phone,
  });

  String get fullAddress =>
      '$recipientName, $addressLine1, $city, $state $postalCode, $country (Phone: $phone)';

  Map<String, dynamic> toMap() => {
        'recipientName': recipientName,
        'addressLine1': addressLine1,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'country': country,
        'phone': phone,
      };

  factory ShippingAddress.fromMap(Map<String, dynamic> map) => ShippingAddress(
        recipientName: map['recipientName'] ?? '',
        addressLine1: map['addressLine1'] ?? '',
        city: map['city'] ?? '',
        state: map['state'] ?? '',
        postalCode: map['postalCode'] ?? '',
        country: map['country'] ?? '',
        phone: map['phone'] ?? '',
      );
}

class OrderModel {
  final String id;
  final String userId;
  final String userEmail;
  final List<CartItem> items;
  final double subtotal;
  final double shippingFee;
  final double tax;
  final double totalAmount;
  final DateTime orderDate;
  OrderStatus status;
  final bool hasPhysicalItems;
  final ShippingAddress? shippingAddress;
  final String paymentMethod;
  final String? bankName;
  final String? transactionReference;
  final bool isPaid;
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.items,
    required this.subtotal,
    this.shippingFee = 0.0,
    this.tax = 0.0,
    required this.totalAmount,
    DateTime? orderDate,
    this.status = OrderStatus.placed,
    required this.hasPhysicalItems,
    this.shippingAddress,
    this.paymentMethod = 'Malaysian FPX Online Banking',
    this.bankName,
    this.transactionReference,
    this.isPaid = true,
    this.trackingNumber,
  }) : orderDate = orderDate ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'userEmail': userEmail,
        'items': items.map((i) => i.toMap()).toList(),
        'subtotal': subtotal,
        'shippingFee': shippingFee,
        'tax': tax,
        'totalAmount': totalAmount,
        'orderDate': orderDate.toIso8601String(),
        'status': status.name,
        'hasPhysicalItems': hasPhysicalItems,
        'shippingAddress': shippingAddress?.toMap(),
        'paymentMethod': paymentMethod,
        'bankName': bankName,
        'transactionReference': transactionReference,
        'isPaid': isPaid,
        'trackingNumber': trackingNumber,
      };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
        id: map['id'],
        userId: map['userId'] ?? '',
        userEmail: map['userEmail'] ?? '',
        items: (map['items'] as List)
            .map((i) => CartItem.fromMap(i))
            .toList(),
        subtotal: (map['subtotal'] as num).toDouble(),
        shippingFee: (map['shippingFee'] as num?)?.toDouble() ?? 0.0,
        tax: (map['tax'] as num?)?.toDouble() ?? 0.0,
        totalAmount: (map['totalAmount'] as num).toDouble(),
        orderDate: DateTime.parse(map['orderDate']),
        status: OrderStatus.values.firstWhere(
          (s) => s.name == map['status'],
          orElse: () => OrderStatus.placed,
        ),
        hasPhysicalItems: map['hasPhysicalItems'] ?? false,
        shippingAddress: map['shippingAddress'] != null
            ? ShippingAddress.fromMap(map['shippingAddress'])
            : null,
        paymentMethod: map['paymentMethod'] ?? 'FPX Online Banking',
        bankName: map['bankName'],
        transactionReference: map['transactionReference'],
        isPaid: map['isPaid'] ?? true,
        trackingNumber: map['trackingNumber'],
      );
}
