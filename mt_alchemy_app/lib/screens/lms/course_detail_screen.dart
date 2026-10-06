import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/navigation_provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final courseProv = context.watch<CourseProvider>();
    final nav = context.read<NavigationProvider>();
    final userId = auth.currentUser?.id ?? 'usr-learner-1';
    final isEnrolled = courseProv.isUserEnrolled(userId, course.id);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Banner with Breadcrumb
          Container(
            width: double.infinity,
            color: const Color(0xFF0F172A),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => nav.navigateTo(AppRoute.lms),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.arrow_back_rounded, size: 16, color: Color(0xFF94A3B8)),
                            SizedBox(width: 6),
                            Text(
                              'Back to Masterclass Catalog',
                              style: TextStyle(
                                color: Color(0xFFCBD5E1),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF7C3AED),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.category,
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.subtitle,
                      style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 15, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                            const SizedBox(width: 4),
                            Text('${course.rating} (${course.reviewCount} reviews)',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person_rounded, color: Color(0xFF94A3B8), size: 18),
                            const SizedBox(width: 4),
                            Text('Instructor: ${course.instructor}',
                                style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.schedule_rounded, color: Color(0xFF94A3B8), size: 18),
                            const SizedBox(width: 4),
                            Text('${course.totalDurationHours} Hours total',
                                style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content & Enrollment Action
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Overview & Curriculum
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'What You Will Master',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 14),
                          ...course.learningOutcomes.map(
                            (outcome) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: Color(0xFF059669), size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(outcome, style: const TextStyle(fontSize: 13.5, height: 1.45)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Curriculum Structure',
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 14),
                          ...course.modules.asMap().entries.map((entry) {
                            final mIndex = entry.key;
                            final module = entry.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: ExpansionTile(
                                initiallyExpanded: mIndex == 0,
                                leading: CircleAvatar(
                                  radius: 13,
                                  backgroundColor: const Color(0xFF6D28D9),
                                  child: Text('${mIndex + 1}',
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                                title: Text(module.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                subtitle: Text('${module.lessons.length} Lessons',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                                children: module.lessons.map((lesson) {
                                  return ListTile(
                                    dense: true,
                                    leading: Icon(
                                      lesson.type == LessonType.video
                                          ? Icons.play_circle_outline
                                          : lesson.type == LessonType.pdf
                                              ? Icons.picture_as_pdf_outlined
                                              : Icons.quiz_outlined,
                                      color: const Color(0xFF7C3AED),
                                      size: 18,
                                    ),
                                    title: Text(lesson.title, style: const TextStyle(fontSize: 13)),
                                    trailing: Text('${lesson.durationMinutes} min',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                  );
                                }).toList(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),

                    // Right: Enrollment Card
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RM ${course.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text('Lifetime Access • Verified Digital Certificate Included',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (!isEnrolled) {
                                    courseProv.enrollCourse(userId, course.id);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Enrolled in ${course.title}! (Journey A Step)'),
                                        backgroundColor: const Color(0xFF059669),
                                      ),
                                    );
                                  }
                                  nav.navigateTo(AppRoute.coursePlayer, course: course);
                                },
                                icon: Icon(isEnrolled ? Icons.play_arrow_rounded : Icons.school_rounded, size: 18),
                                label: Text(isEnrolled ? 'Resume Course (65% Demo)' : 'Enrol Now (Journey A)'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isEnrolled ? const Color(0xFF059669) : const Color(0xFF6D28D9),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Divider(color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 12),
                            _perkRow(Icons.all_inclusive, 'Full Lifetime Access'),
                            _perkRow(Icons.devices, 'Access on Mobile, Tablet & Desktop'),
                            _perkRow(Icons.assignment_turned_in, 'Interactive Assessment Quiz'),
                            _perkRow(Icons.card_membership, 'Official Certificate of Completion'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _perkRow(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6D28D9)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}
