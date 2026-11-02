import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course_model.dart';
import '../../models/enquiry_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../models/user_model.dart';
import '../../providers/course_provider.dart';
import '../../providers/enquiry_provider.dart';
import '../../providers/store_provider.dart';
import '../../services/mock_database_service.dart';
import '../../widgets/role_badge.dart';

class AdminPortalScreen extends StatelessWidget {
  const AdminPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProv = context.watch<CourseProvider>();
    final store = context.watch<StoreProvider>();
    final enquiryProv = context.watch<EnquiryProvider>();
    final db = MockDatabaseService();

    return DefaultTabController(
      length: 6,
      child: Container(
        color: const Color(0xFFF8FAFC),
        child: Column(
          children: [
            // Top Executive Header & KPI Overview Banner
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFFDE68A)),
                                    ),
                                    child: const Text(
                                      'ENTERPRISE CONTROL CONSOLE',
                                      style: TextStyle(
                                        color: Color(0xFF92400E),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFECFDF5),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFA7F3D0)),
                                    ),
                                    child: const Text(
                                      'SYSTEM ONLINE',
                                      style: TextStyle(
                                        color: Color(0xFF065F46),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Super Admin Management Portal',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Full CRUD governance for learning curricula, facilitation e-store, platform accounts & enterprise proposals.',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3FF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFDDD6FE)),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.shield_rounded, color: Color(0xFF6D28D9), size: 22),
                                SizedBox(width: 8),
                                Text(
                                  'Root Administrator',
                                  style: TextStyle(
                                    color: Color(0xFF6D28D9),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // KPI Metric Summary Cards
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildKpiCard(
                            title: 'Active Masterclasses',
                            value: '${courseProv.courses.length}',
                            subtitle: 'LMS Curricula',
                            icon: Icons.school_rounded,
                            accentColor: const Color(0xFF6D28D9),
                            bgColor: const Color(0xFFF5F3FF),
                          ),
                          _buildKpiCard(
                            title: 'Store Inventory',
                            value: '${store.allProducts.length}',
                            subtitle: 'Digital & Physical',
                            icon: Icons.inventory_2_rounded,
                            accentColor: const Color(0xFF059669),
                            bgColor: const Color(0xFFECFDF5),
                          ),
                          _buildKpiCard(
                            title: 'Registered Users',
                            value: '${db.users.length}',
                            subtitle: 'RBAC Accounts',
                            icon: Icons.people_alt_rounded,
                            accentColor: const Color(0xFF2563EB),
                            bgColor: const Color(0xFFEFF6FF),
                          ),
                          _buildKpiCard(
                            title: 'Corporate RFPs',
                            value: '${enquiryProv.enquiries.length}',
                            subtitle: 'Client Inquiries',
                            icon: Icons.business_center_rounded,
                            accentColor: const Color(0xFFD97706),
                            bgColor: const Color(0xFFFFFBEB),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Modern Segmented Tab Bar
                      TabBar(
                        isScrollable: true,
                        labelColor: const Color(0xFF6D28D9),
                        unselectedLabelColor: const Color(0xFF64748B),
                        indicatorColor: const Color(0xFF6D28D9),
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        tabs: [
                          Tab(
                            icon: const Icon(Icons.school_rounded, size: 16),
                            text: 'Courses (${courseProv.courses.length})',
                          ),
                          Tab(
                            icon: const Icon(Icons.shopping_bag_rounded, size: 16),
                            text: 'Products (${store.allProducts.length})',
                          ),
                          Tab(
                            icon: const Icon(Icons.local_shipping_rounded, size: 16),
                            text: 'Orders (${store.orders.length})',
                          ),
                          Tab(
                            icon: const Icon(Icons.people_rounded, size: 16),
                            text: 'Users & Roles (${db.users.length})',
                          ),
                          Tab(
                            icon: const Icon(Icons.mail_rounded, size: 16),
                            text: 'Enquiries (${enquiryProv.enquiries.length})',
                          ),
                          const Tab(
                            icon: Icon(Icons.shield_rounded, size: 16),
                            text: 'Audit Logs',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                children: [
                  _CoursesCrudTab(courseProv: courseProv),
                  _ProductsCrudTab(store: store),
                  _OrdersCrudTab(store: store),
                  _UsersCrudTab(users: db.users),
                  _EnquiriesTab(enquiryProv: enquiryProv),
                  const _AuditLogsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required Color bgColor,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CoursesCrudTab extends StatelessWidget {
  final CourseProvider courseProv;

  const _CoursesCrudTab({required this.courseProv});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Action Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Curriculum Masterclasses (CRUD)',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Create, update or retire emotional intelligence & leadership courses.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddCourseDialog(context, courseProv),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Create New Course'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Course List
              ...courseProv.courses.map((course) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Course Icon
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF7C3AED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 18),

                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F3FF),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFFDDD6FE)),
                                  ),
                                  child: Text(
                                    course.category.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF6D28D9),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    course.badge,
                                    style: const TextStyle(
                                      color: Color(0xFF92400E),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              course.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${course.totalLessons} Lessons • ${course.totalDurationHours} Hours • Lead: ${course.instructor}',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),

                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Tuition Fee', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          Text(
                            'RM ${course.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),

                      // Actions
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _showEditCourseDialog(context, courseProv, course),
                            icon: const Icon(Icons.edit_outlined, size: 16),
                            label: const Text('Edit'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF2563EB),
                              side: const BorderSide(color: Color(0xFFBFDBFE)),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: 'Delete Course',
                            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                            onPressed: () {
                              _confirmDelete(context, () {
                                courseProv.deleteCourse(course.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Course "${course.title}" removed.')),
                                );
                              });
                            },
                          ),
                        ],
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

  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to remove this item? This action is immediate.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog(BuildContext context, CourseProvider courseProv) {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '299.00');
    final descCtrl = TextEditingController(text: 'Experiential executive cohort designed for emotional agility.');
    String category = 'Emotional Intelligence';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Masterclass Course', style: TextStyle(fontWeight: FontWeight.w800)),
          content: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Course Title', hintText: 'e.g. Mindful Executive Resilience'),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(labelText: 'Price (RM)', prefixText: 'RM '),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(value: 'Emotional Intelligence', child: Text('Emotional Intelligence')),
                    DropdownMenuItem(value: 'Workplace Well-being', child: Text('Workplace Well-being')),
                    DropdownMenuItem(value: 'Team Engagement', child: Text('Team Engagement')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Short Description'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  final newCourse = Course(
                    id: 'course-${DateTime.now().millisecondsSinceEpoch}',
                    title: titleCtrl.text.trim(),
                    subtitle: 'Master key people development concepts with MT Alchemy.',
                    description: descCtrl.text.trim(),
                    category: category,
                    instructor: 'MT Alchemy Senior Consultant',
                    price: double.tryParse(priceCtrl.text) ?? 299.00,
                    totalDurationHours: 6,
                    learningOutcomes: ['Enhance workplace emotional agility'],
                    modules: [
                      CourseModule(
                        id: 'mod-1',
                        title: 'Foundations & Mindset Shift',
                        lessons: [
                          Lesson(
                            id: 'l-new-1',
                            title: 'Core Foundations of Emotional Intelligence',
                            durationMinutes: 15,
                            type: LessonType.video,
                            contentUrl: 'https://sample-videos.com/video321/mp4/720/big_buck_bunny_720p_1mb.mp4',
                            notes: 'Introduction to emotional regulation and executive presence.',
                          ),
                        ],
                      ),
                    ],
                  );
                  courseProv.addCourse(newCourse);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Course added successfully!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D28D9),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Masterclass'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditCourseDialog(BuildContext context, CourseProvider courseProv, Course course) {
    final titleCtrl = TextEditingController(text: course.title);
    final priceCtrl = TextEditingController(text: course.price.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Edit Course Details', style: TextStyle(fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Course Title'),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price (RM)', prefixText: 'RM '),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final updated = Course(
                id: course.id,
                title: titleCtrl.text.trim(),
                subtitle: course.subtitle,
                description: course.description,
                category: course.category,
                instructor: course.instructor,
                price: double.tryParse(priceCtrl.text) ?? course.price,
                totalDurationHours: course.totalDurationHours,
                learningOutcomes: course.learningOutcomes,
                modules: course.modules,
                badge: course.badge,
                rating: course.rating,
                reviewCount: course.reviewCount,
              );
              courseProv.updateCourse(updated);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Course updated successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6D28D9),
              foregroundColor: Colors.white,
            ),
            child: const Text('Update Course'),
          ),
        ],
      ),
    );
  }
}

class _ProductsCrudTab extends StatelessWidget {
  final StoreProvider store;

  const _ProductsCrudTab({required this.store});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'E-Store Product Inventory (CRUD)',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Manage digital PDF toolkits and physical facilitation hardware kits.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddProductDialog(context, store),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Store Product'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ...store.allProducts.map((p) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: p.isDigital ? const Color(0xFFF5F3FF) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: p.isDigital ? const Color(0xFFDDD6FE) : const Color(0xFFFDE68A),
                          ),
                        ),
                        child: Icon(
                          p.isDigital ? Icons.picture_as_pdf_rounded : Icons.inventory_2_rounded,
                          color: p.isDigital ? const Color(0xFF6D28D9) : const Color(0xFF92400E),
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: p.isDigital ? const Color(0xFFF5F3FF) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                p.isDigital ? 'DIGITAL DOWNLOAD (JOURNEY B)' : 'PHYSICAL HARDWARE (JOURNEY C)',
                                style: TextStyle(
                                  color: p.isDigital ? const Color(0xFF6D28D9) : const Color(0xFF92400E),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${p.description} • Stock: ${p.stockQuantity} units',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Retail Price', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          Text(
                            'RM ${p.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        tooltip: 'Delete Product',
                        icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                        onPressed: () {
                          store.deleteProduct(p.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Product "${p.name}" deleted.')),
                          );
                        },
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

  void _showAddProductDialog(BuildContext context, StoreProvider store) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '49.00');
    final descCtrl = TextEditingController(text: 'Exclusive MT Alchemy facilitation resource.');
    ProductType pType = ProductType.digital;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Add Store Product', style: TextStyle(fontWeight: FontWeight.w800)),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Product Name'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(labelText: 'Price (RM)', prefixText: 'RM '),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<ProductType>(
                    initialValue: pType,
                    decoration: const InputDecoration(labelText: 'Product Format'),
                    items: const [
                      DropdownMenuItem(
                        value: ProductType.digital,
                        child: Text('Digital Download (PDF / Toolkit - Journey B)'),
                      ),
                      DropdownMenuItem(
                        value: ProductType.physical,
                        child: Text('Physical Shipment (Facilitation Cards - Journey C)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setDialogState(() => pType = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty) {
                    final newProduct = Product(
                      id: 'prod-${DateTime.now().millisecondsSinceEpoch}',
                      name: nameCtrl.text.trim(),
                      description: descCtrl.text.trim(),
                      price: double.tryParse(priceCtrl.text) ?? 49.00,
                      type: pType,
                      category: 'Leadership & Well-being',
                      imageUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=600&auto=format&fit=crop&q=80',
                      stockQuantity: pType == ProductType.digital ? 999 : 25,
                      digitalDownloadUrl: pType == ProductType.digital ? 'https://mtalchemy.com/download/resource.pdf' : null,
                    );
                    store.addProduct(newProduct);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added successfully!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Product'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OrdersCrudTab extends StatelessWidget {
  final StoreProvider store;

  const _OrdersCrudTab({required this.store});

  @override
  Widget build(BuildContext context) {
    final orders = store.orders;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Orders & Fulfillment Management',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Monitor order lifecycle, track shipments, advance statuses, or process refunds.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      '${orders.length} Total Orders',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E40AF),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (orders.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.inbox_rounded, size: 48, color: Color(0xFF94A3B8)),
                      SizedBox(height: 12),
                      Text(
                        'No orders recorded yet.',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ...orders.map((order) {
                final isTerminated = order.status == OrderStatus.cancelled || order.status == OrderStatus.refunded;
                Color statusColor;
                Color statusBg;
                switch (order.status) {
                  case OrderStatus.placed:
                    statusColor = const Color(0xFF2563EB);
                    statusBg = const Color(0xFFEFF6FF);
                    break;
                  case OrderStatus.processing:
                    statusColor = const Color(0xFFD97706);
                    statusBg = const Color(0xFFFEF3C7);
                    break;
                  case OrderStatus.shipped:
                    statusColor = const Color(0xFF7C3AED);
                    statusBg = const Color(0xFFF5F3FF);
                    break;
                  case OrderStatus.delivered:
                    statusColor = const Color(0xFF059669);
                    statusBg = const Color(0xFFECFDF5);
                    break;
                  case OrderStatus.cancelled:
                  case OrderStatus.refunded:
                    statusColor = const Color(0xFFDC2626);
                    statusBg = const Color(0xFFFEF2F2);
                    break;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: statusBg,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.receipt_long_rounded, color: statusColor, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        order.id,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: statusBg,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                                        ),
                                        child: Text(
                                          order.status.displayName,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Buyer: ${order.userEmail} • Txn: ${order.transactionReference ?? "N/A"}',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            'RM ${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 14),

                      // Order Items
                      const Text(
                        'Purchased Items:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: order.items.map((it) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(
                              '${it.quantity}x ${it.product.name} (RM ${it.product.price.toStringAsFixed(2)})',
                              style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                            ),
                          );
                        }).toList(),
                      ),

                      if (order.shippingAddress != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, size: 16, color: Color(0xFF64748B)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ship To: ${order.shippingAddress!.fullAddress}'
                                  '${order.trackingNumber != null ? " • Tracking: ${order.trackingNumber}" : ""}',
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),
                      // Action Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isTerminated) ...[
                            OutlinedButton.icon(
                              onPressed: () {
                                _showCancelOrderDialog(context, order.id);
                              },
                              icon: const Icon(Icons.cancel_outlined, size: 15, color: Color(0xFFDC2626)),
                              label: const Text('Cancel & Refund', style: TextStyle(color: Color(0xFFDC2626))),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFCA5A5)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (order.status != OrderStatus.delivered)
                              ElevatedButton.icon(
                                onPressed: () {
                                  store.advanceOrderStatus(order.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Order ${order.id} advanced to next stage.')),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                                label: Text(
                                  order.status == OrderStatus.placed
                                      ? 'Start Processing'
                                      : order.status == OrderStatus.processing
                                          ? 'Mark Shipped'
                                          : 'Mark Delivered',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6D28D9),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                          ],
                        ],
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

  void _showCancelOrderDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel & Refund Order'),
        content: Text('Are you sure you want to cancel order $orderId? Stock will be restored and payment refunded.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Dismiss')),
          ElevatedButton(
            onPressed: () async {
              final ref = await store.cancelOrder(orderId, reason: 'Super Admin cancellation & payment refund');
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order $orderId refunded ($ref) & stock restored.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            child: const Text('Confirm Cancellation & Refund'),
          ),
        ],
      ),
    );
  }
}

class _UsersCrudTab extends StatefulWidget {
  final List<UserModel> users;

  const _UsersCrudTab({required this.users});

  @override
  State<_UsersCrudTab> createState() => _UsersCrudTabState();
}

class _UsersCrudTabState extends State<_UsersCrudTab> {
  late List<UserModel> _userList;

  @override
  void initState() {
    super.initState();
    _userList = List.from(widget.users);
  }

  UserRole _roleFromString(String roleStr) {
    switch (roleStr) {
      case 'guest':
        return UserRole.guest;
      case 'employer':
        return UserRole.employer;
      case 'trainer':
        return UserRole.trainer;
      case 'superAdmin':
        return UserRole.superAdmin;
      case 'individual':
      default:
        return UserRole.individual;
    }
  }

  void _changeUserRole(UserModel user, String newRoleStr) async {
    final parsedRole = _roleFromString(newRoleStr);
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        'role': newRoleStr,
      });

      // Audit log
      await FirebaseFirestore.instance.collection('audit_logs').add({
        'userId': 'super_admin',
        'role': 'superAdmin',
        'event': 'ROLE_CHANGE',
        'details': 'Changed role of ${user.email} from ${user.role.name} to $newRoleStr',
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        final idx = _userList.indexWhere((u) => u.id == user.id);
        if (idx >= 0) {
          _userList[idx] = user.copyWith(role: parsedRole);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated ${user.name}\'s role to ${newRoleStr.toUpperCase()}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Role update note: $e (Updated locally)')),
        );
        setState(() {
          final idx = _userList.indexWhere((u) => u.id == user.id);
          if (idx >= 0) {
            _userList[idx] = user.copyWith(role: parsedRole);
          }
        });
      }
    }
  }

  void _showRoleDialog(UserModel user) {
    String selectedRole = user.role.name;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text('Change Role: ${user.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Role: ${user.role.displayName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Select New RBAC Role:'),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'guest', child: Text('Guest (Unauthenticated)')),
                  DropdownMenuItem(value: 'individual', child: Text('Individual Learner')),
                  DropdownMenuItem(value: 'employer', child: Text('Corporate Employer')),
                  DropdownMenuItem(value: 'trainer', child: Text('Trainer / Facilitator')),
                  DropdownMenuItem(value: 'superAdmin', child: Text('Super Admin')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() => selectedRole = val);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _changeUserRole(user, selectedRole);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D28D9), foregroundColor: Colors.white),
              child: const Text('Save Role'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Directory & Role-Based Access Control (RBAC)',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Governance of the 5 coursework roles (Guest, Individual, Employer, Trainer, Super Admin). Change roles securely.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              ..._userList.map((user) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFF0F172A),
                        child: Text(
                          user.name.isNotEmpty ? user.name[0] : 'U',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${user.email} • Country: ${user.country ?? "Malaysia"} • Hobbies: ${user.hobbies.join(", ")}',
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      RoleBadge(role: user.role),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _showRoleDialog(user),
                        icon: const Icon(Icons.manage_accounts_rounded, size: 16),
                        label: const Text('Manage Role', style: TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

class _AuditLogsTab extends StatelessWidget {
  const _AuditLogsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security & Compliance Audit Logs',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Real-time immutable security events captured across authentication, role assignments, and payment flows.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('audit_logs')
                    .orderBy('timestamp', descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      padding: const EdgeInsets.all(48),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          CircularProgressIndicator(color: Color(0xFF6D28D9)),
                          SizedBox(height: 16),
                          Text('Streaming real-time security events from Firestore...', style: TextStyle(color: Color(0xFF64748B))),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFCA5A5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Unable to load audit logs: ${snapshot.error}. Ensure you are signed in as Super Admin.',
                              style: const TextStyle(color: Color(0xFF991B1B), fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(48),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.shield_outlined, size: 48, color: Color(0xFF94A3B8)),
                          SizedBox(height: 14),
                          Text(
                            'No Security Audit Logs in Firestore',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Live audit records will appear here as users authenticate, make payments, and update roles.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final event = data['action']?.toString() ?? data['event']?.toString() ?? 'SYSTEM_EVENT';
                      final details = data['details']?.toString() ?? '';
                      final userId = data['userId']?.toString() ?? 'system';
                      final role = data['role']?.toString() ?? 'user';
                      final ts = data['timestamp'];
                      String timeStr = 'Recent';
                      if (ts is Timestamp) {
                        timeStr = ts.toDate().toLocal().toString().split('.').first;
                      }

                      return _buildLogCard(
                        event: event,
                        details: details,
                        userId: userId,
                        role: role,
                        time: timeStr,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogCard({
    required String event,
    required String details,
    required String userId,
    required String role,
    required String time,
  }) {
    Color badgeColor;
    Color badgeBg;
    if (event.contains('FAIL') || event.contains('ALERT')) {
      badgeColor = const Color(0xFFDC2626);
      badgeBg = const Color(0xFFFEF2F2);
    } else if (event.contains('AUTH') || event.contains('ROLE')) {
      badgeColor = const Color(0xFF7C3AED);
      badgeBg = const Color(0xFFF5F3FF);
    } else if (event.contains('PAYMENT') || event.contains('SUCCESS')) {
      badgeColor = const Color(0xFF059669);
      badgeBg = const Color(0xFFECFDF5);
    } else {
      badgeColor = const Color(0xFF2563EB);
      badgeBg = const Color(0xFFEFF6FF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              event,
              style: TextStyle(color: badgeColor, fontWeight: FontWeight.w700, fontSize: 11),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 4),
                Text(
                  'User: $userId • Role: $role • $time',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF059669), size: 18),
        ],
      ),
    );
  }
}

class _EnquiriesTab extends StatelessWidget {
  final EnquiryProvider enquiryProv;

  const _EnquiriesTab({required this.enquiryProv});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Corporate Enquiries & Customized Proposals',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Enterprise RFPs submitted by HR Directors, Talent Heads & C-Suite leaders.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              if (enquiryProv.enquiries.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  alignment: Alignment.center,
                  child: const Text('No corporate proposals submitted yet.'),
                ),
              ...enquiryProv.enquiries.map((enq) {
                final isSent = enq.status == EnquiryStatus.proposalSent;
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.corporate_fare_rounded, color: Color(0xFF2563EB), size: 22),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    enq.companyName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Contact: ${enq.contactPerson} (${enq.email} • ${enq.phone})',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: isSent ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSent ? const Color(0xFFA7F3D0) : const Color(0xFFBFDBFE)),
                            ),
                            child: Text(
                              isSent ? 'PROPOSAL SENT' : 'PENDING REVIEW',
                              style: TextStyle(
                                color: isSent ? const Color(0xFF065F46) : const Color(0xFF1E40AF),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _buildDetailBadge('Cohort Size', '${enq.participantsCount} Executives'),
                          const SizedBox(width: 14),
                          _buildDetailBadge('Delivery Mode', enq.deliveryMode),
                          const SizedBox(width: 14),
                          _buildDetailBadge('Pillars', enq.topicsInterested.join(", ")),
                        ],
                      ),
                      if (enq.customRequirements.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Text(
                            'Special Notes: "${enq.customRequirements}"',
                            style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              enquiryProv.updateEnquiryStatus(enq.id, EnquiryStatus.proposalSent);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Custom proposal dispatched to client!')),
                              );
                            },
                            icon: const Icon(Icons.send_rounded, size: 16),
                            label: Text(isSent ? 'Resend Tailored Proposal' : 'Dispatch Tailored Proposal'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSent ? const Color(0xFF059669) : const Color(0xFF6D28D9),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
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

  static Widget _buildDetailBadge(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }
}
