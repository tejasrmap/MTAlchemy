import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/order_model.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/store_provider.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<StoreProvider>();
    final nav = context.read<NavigationProvider>();

    final currentOrder = store.orders.firstWhere(
      (o) => o.id == order.id,
      orElse: () => order,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              InkWell(
                onTap: () => nav.navigateTo(AppRoute.store),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF64748B)),
                      SizedBox(width: 6),
                      Text(
                        'Back to E-Store',
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
              const SizedBox(height: 18),

              // Banner for Journey C
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_shipping_rounded, color: Color(0xFFD97706), size: 28),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'JOURNEY C PHYSICAL TRACKING: Tracking ${currentOrder.id}. Courier Tracking Number: ${currentOrder.trackingNumber ?? "MYS-987123"}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF92400E)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        store.advanceOrderStatus(currentOrder.id);
                      },
                      icon: const Icon(Icons.fast_forward_rounded, size: 16),
                      label: const Text('Advance Status (Demo)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F172A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        textStyle: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Stepper Visual
              Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fulfillment & Delivery Stepper',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 24),
                    _buildStepRow(
                      title: 'Order Placed',
                      subtitle: 'Your payment was confirmed and order received.',
                      isCompleted: currentOrder.status.stepIndex >= 0,
                      isActive: currentOrder.status.stepIndex == 0,
                    ),
                    _buildStepLine(currentOrder.status.stepIndex >= 1),
                    _buildStepRow(
                      title: 'Processing & Preparing',
                      subtitle: 'Items packed at MT Alchemy Fulfillment Center (Kuala Lumpur).',
                      isCompleted: currentOrder.status.stepIndex >= 1,
                      isActive: currentOrder.status.stepIndex == 1,
                    ),
                    _buildStepLine(currentOrder.status.stepIndex >= 2),
                    _buildStepRow(
                      title: 'Shipped / In Transit',
                      subtitle: 'Handed to courier. Tracking: ${currentOrder.trackingNumber ?? "MYPOS-892147-EXP"}',
                      isCompleted: currentOrder.status.stepIndex >= 2,
                      isActive: currentOrder.status.stepIndex == 2,
                    ),
                    _buildStepLine(currentOrder.status.stepIndex >= 3),
                    _buildStepRow(
                      title: 'Delivered Successfully',
                      subtitle: 'Package signed and received by recipient.',
                      isCompleted: currentOrder.status.stepIndex >= 3,
                      isActive: currentOrder.status.stepIndex == 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Shipping Address Details
              if (currentOrder.shippingAddress != null) ...[
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: Color(0xFF6D28D9)),
                          SizedBox(width: 8),
                          Text('Recipient & Shipping Destination',
                              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A))),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentOrder.shippingAddress!.fullAddress,
                        style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF334155)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Order Items Summary
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ordered Items',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A))),
                    const SizedBox(height: 14),
                    ...currentOrder.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.product.name} (x${item.quantity})',
                                style: const TextStyle(fontSize: 14, color: Color(0xFF334155))),
                            Text('RM ${item.totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount Paid:',
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A))),
                        Text('RM ${currentOrder.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFF059669) : Colors.grey.shade300,
            shape: BoxShape.circle,
            border: isActive ? Border.all(color: const Color(0xFF6D28D9), width: 3) : null,
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.circle,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isCompleted ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isDone) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      width: 2,
      height: 30,
      color: isDone ? const Color(0xFF059669) : Colors.grey.shade300,
    );
  }
}
