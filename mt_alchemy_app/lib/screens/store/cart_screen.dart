import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/store_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final nav = context.read<NavigationProvider>();

    if (store.cart.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_bag_outlined, size: 56, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Shopping Cart is Empty',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore our digital EQ guides, mindfulness audios, and executive facilitation card decks.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF64748B), fontSize: 13.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => nav.navigateTo(AppRoute.store),
                icon: const Icon(Icons.storefront_rounded, size: 18),
                label: const Text('Browse E-Store Products'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D28D9),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            children: [
              // Breadcrumb & In-page Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => nav.navigateTo(AppRoute.store),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF64748B)),
                          SizedBox(width: 6),
                          Text(
                            'Back to E-Store Products',
                            style: TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => store.clearCart(),
                    icon: const Icon(Icons.delete_sweep_rounded, size: 18, color: Color(0xFFEF4444)),
                    label: const Text('Clear Cart', style: TextStyle(color: Color(0xFFEF4444))),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 800;

                  final itemsWidget = Column(
                      children: store.cart.map((item) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: item.product.isDigital ? const Color(0xFFFAF5FF) : const Color(0xFFFFFBEB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  item.product.isDigital ? Icons.picture_as_pdf_rounded : Icons.inventory_2_rounded,
                                  color: item.product.isDigital ? const Color(0xFF7C3AED) : const Color(0xFFD97706),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.product.isDigital ? 'DIGITAL (Instant Download)' : 'PHYSICAL (Shipped)',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: item.product.isDigital ? const Color(0xFF6D28D9) : const Color(0xFFD97706),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'RM ${item.product.price.toStringAsFixed(2)} each',
                                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20, color: Color(0xFF64748B)),
                                    onPressed: () => store.updateQuantity(item.product.id, item.quantity - 1),
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF64748B)),
                                    onPressed: () => store.updateQuantity(item.product.id, item.quantity + 1),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'RM ${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF0F172A)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 18),
                                onPressed: () => store.removeFromCart(item.product.id),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );

                  final summaryWidget = Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Order Summary',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                        const SizedBox(height: 18),
                        _row('Subtotal (${store.cartCount} items)', 'RM ${store.cartSubtotal.toStringAsFixed(2)}'),
                        _row(
                          'Shipping & Delivery',
                          store.hasPhysicalItems ? 'RM 15.00' : 'FREE (Digital Delivery)',
                          highlight: !store.hasPhysicalItems,
                        ),
                        _row('SST Tax (6%)', 'RM ${store.tax.toStringAsFixed(2)}'),
                        const Divider(height: 28, color: Color(0xFFF1F5F9)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grand Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                            Text(
                              'RM ${store.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => nav.navigateTo(AppRoute.checkout),
                            icon: const Icon(Icons.lock_rounded, size: 18),
                            label: const Text('Proceed to Secure Checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6D28D9),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        itemsWidget,
                        const SizedBox(height: 20),
                        summaryWidget,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: itemsWidget),
                      const SizedBox(width: 28),
                      Expanded(flex: 2, child: summaryWidget),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: highlight ? const Color(0xFF059669) : const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
