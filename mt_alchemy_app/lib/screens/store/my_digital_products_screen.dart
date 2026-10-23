import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/store_provider.dart';

class MyDigitalProductsScreen extends StatelessWidget {
  const MyDigitalProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final store = context.watch<StoreProvider>();
    final nav = context.read<NavigationProvider>();
    final userId = auth.currentUser?.id ?? 'usr-learner-1';
    final digitalProducts = store.getUserDigitalProducts(userId);

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

              // Info Banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDDD6FE)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.cloud_download_rounded, color: Color(0xFF6D28D9), size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'JOURNEY B VERIFICATION: Instant access to your purchased digital guides, audiobooks, and toolkits. All licenses are personal and non-expiring.',
                        style: TextStyle(
                          color: Color(0xFF5B21B6),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Your Purchased Digital Library',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),
              ...digitalProducts.map((p) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.file_download_done_rounded, color: Color(0xFF6D28D9), size: 30),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Category: ${p.category} • Lifetime License Active',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading "${p.name}" securely...'),
                              backgroundColor: const Color(0xFF059669),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download_rounded, size: 16),
                        label: const Text('Download File'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F172A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
