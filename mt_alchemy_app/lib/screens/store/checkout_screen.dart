import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/validators.dart';
import '../../models/order_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/store_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Alex Chen');
  final _addressController = TextEditingController(text: 'Level 18, Menara Horizon, Jalan Ampang');
  final _cityController = TextEditingController(text: 'Kuala Lumpur');
  final _stateController = TextEditingController(text: 'Wilayah Persekutuan');
  final _postalController = TextEditingController(text: '50450');
  final _phoneController = TextEditingController(text: '+60 12-345 6789');

  String _selectedPayment = 'FPX Online Banking (Maybank / CIMB / Public)';
  String _selectedCountry = 'Malaysia';

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final store = context.watch<StoreProvider>();
    final nav = context.read<NavigationProvider>();
    final hasPhysical = store.hasPhysicalItems;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // In-page Breadcrumb
                InkWell(
                  onTap: () => nav.navigateTo(AppRoute.cart),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF64748B)),
                        SizedBox(width: 6),
                        Text(
                          'Back to Shopping Cart',
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

                // Journey Notice
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: hasPhysical ? const Color(0xFFFFFBEB) : const Color(0xFFF5F3FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasPhysical ? const Color(0xFFFDE68A) : const Color(0xFFDDD6FE),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasPhysical ? Icons.local_shipping_rounded : Icons.download_for_offline_rounded,
                        color: hasPhysical ? const Color(0xFFD97706) : const Color(0xFF6D28D9),
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          hasPhysical
                              ? 'JOURNEY C CHECKOUT: Your cart contains physical items. Please provide your delivery shipping address below.'
                              : 'JOURNEY B CHECKOUT: Your cart contains digital items. You will receive immediate direct download links upon confirmation.',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: hasPhysical ? const Color(0xFF92400E) : const Color(0xFF5B21B6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Shipping Address Form (if physical items present)
                if (hasPhysical) ...[
                  const Text(
                    'Delivery Shipping Address',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Recipient Full Name *',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (val) => AppValidators.validateRequired(val, 'Recipient Name'),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Street Address (Unit / Building / Road) *',
                      prefixIcon: Icon(Icons.home_outlined),
                    ),
                    validator: (val) => AppValidators.validateRequired(val, 'Street Address'),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(labelText: 'City *'),
                          validator: (val) => AppValidators.validateRequired(val, 'City'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(labelText: 'State / Province *'),
                          validator: (val) => AppValidators.validateRequired(val, 'State'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _postalController,
                          decoration: const InputDecoration(labelText: 'Postal Code *'),
                          validator: (val) => AppValidators.validateRequired(val, 'Postal Code'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedCountry,
                          decoration: const InputDecoration(labelText: 'Country *'),
                          items: const [
                            DropdownMenuItem(value: 'Malaysia', child: Text('Malaysia')),
                            DropdownMenuItem(value: 'Singapore', child: Text('Singapore')),
                            DropdownMenuItem(value: 'Brunei', child: Text('Brunei')),
                            DropdownMenuItem(value: 'Indonesia', child: Text('Indonesia')),
                          ],
                          onChanged: (val) {
                            setState(() {
                              _selectedCountry = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Phone Number *',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (val) => AppValidators.validateRequired(val, 'Phone Number'),
                  ),
                  const SizedBox(height: 28),
                ],

                // Payment Method Section
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 14),
                Card(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        value: 'FPX Online Banking (Maybank / CIMB / Public)',
                        groupValue: _selectedPayment,
                        title: const Text('FPX Online Banking (Instant Gateway)'),
                        subtitle: const Text('Direct debit from Malaysian online banking institutions'),
                        secondary: const Icon(Icons.account_balance, color: Color(0xFF6D28D9)),
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        value: 'Credit / Debit Card (Visa / Mastercard)',
                        groupValue: _selectedPayment,
                        title: const Text('Credit / Debit Card'),
                        subtitle: const Text('Secured 256-bit SSL encrypted card transaction'),
                        secondary: const Icon(Icons.credit_card, color: Color(0xFF0F172A)),
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                      ),
                      const Divider(height: 1),
                      RadioListTile<String>(
                        value: 'Corporate Invoice / Purchase Order',
                        groupValue: _selectedPayment,
                        title: const Text('Corporate Purchase Order (PO)'),
                        subtitle: const Text('Available for verified enterprise accounts (30-day term)'),
                        secondary: const Icon(Icons.receipt_long, color: Color(0xFF0D9488)),
                        onChanged: (val) => setState(() => _selectedPayment = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Order Summary Breakdown
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Payment Summary',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A))),
                      const SizedBox(height: 16),
                      _summaryRow('Subtotal (${store.cartCount} items):', 'RM ${store.cartSubtotal.toStringAsFixed(2)}'),
                      _summaryRow('Shipping & Handling:', hasPhysical ? 'RM 15.00' : 'FREE (Digital Delivery)'),
                      _summaryRow('SST Tax (6%):', 'RM ${store.tax.toStringAsFixed(2)}'),
                      const Divider(height: 24, color: Color(0xFFF1F5F9)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text(
                            'RM ${store.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (hasPhysical && !_formKey.currentState!.validate()) {
                        return;
                      }

                      final userId = auth.currentUser?.id ?? 'usr-learner-1';
                      final userEmail = auth.currentUser?.email ?? 'alex.chen@student.com';

                      ShippingAddress? address;
                      if (hasPhysical) {
                        address = ShippingAddress(
                          recipientName: _nameController.text.trim(),
                          addressLine1: _addressController.text.trim(),
                          city: _cityController.text.trim(),
                          state: _stateController.text.trim(),
                          postalCode: _postalController.text.trim(),
                          country: _selectedCountry,
                          phone: _phoneController.text.trim(),
                        );
                      }

                      try {
                        final createdOrder = await store.checkout(
                          userId: userId,
                          userEmail: userEmail,
                          paymentMethod: _selectedPayment,
                          bankName: _selectedPayment.contains('FPX') ? 'Maybank2u' : null,
                          shippingAddress: address,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Payment confirmed! Order ${createdOrder.id} placed.'),
                            backgroundColor: const Color(0xFF059669),
                          ),
                        );

                        if (hasPhysical) {
                          nav.navigateTo(AppRoute.orderTracking, order: createdOrder);
                        } else {
                          nav.navigateTo(AppRoute.myDownloads);
                        }
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Checkout failed: $e'),
                            backgroundColor: const Color(0xFFDC2626),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.lock_rounded, size: 18),
                    label: Text(
                      hasPhysical
                          ? 'Pay & Track Physical Shipment (Journey C)'
                          : 'Pay & Access Digital Downloads (Journey B)',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13.5)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}
