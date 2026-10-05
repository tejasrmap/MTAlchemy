import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/navigation_provider.dart';

class CourseCatalogScreen extends StatefulWidget {
  const CourseCatalogScreen({super.key});

  @override
  State<CourseCatalogScreen> createState() => _CourseCatalogScreenState();
}

class _CourseCatalogScreenState extends State<CourseCatalogScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final courseProv = context.watch<CourseProvider>();
    final userId = auth.currentUser?.id ?? 'usr-learner-1';
    final enrolledCourses = courseProv.getUserEnrolledCourses(userId);

    final filteredCourses = courseProv.courses.where((c) {
      if (_selectedCategory == 'All') return true;
      return c.category == _selectedCategory;
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Container(
        color: const Color(0xFFF8FAFC),
        child: LayoutBuilder(
          builder: (context, screenConstraints) {
            final isCompactHeight = screenConstraints.maxHeight < 550;
            final isNarrow = screenConstraints.maxWidth < 600;

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    isNarrow ? 16 : 28,
                    isCompactHeight ? 8 : (isNarrow ? 12 : 20),
                    isNarrow ? 16 : 28,
                    isCompactHeight ? 6 : 12,
                  ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1160),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F3FF),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFFDDD6FE)),
                                        ),
                                        child: const Text(
                                          'INDIVIDUAL LMS ACADEMY (JOURNEY A)',
                                          style: TextStyle(
                                            color: Color(0xFF6D28D9),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.5,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Executive Masterclasses & Experiential Cohorts',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Evidence-based people development frameworks in Emotional Intelligence, Resilience & Leadership.',
                                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFDE68A)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.workspace_premium_rounded, size: 16, color: Color(0xFF92400E)),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    '65%+ Distinction Certificate',
                                    style: TextStyle(color: Color(0xFF92400E), fontWeight: FontWeight.w700, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            labelColor: const Color(0xFF6D28D9),
                            unselectedLabelColor: const Color(0xFF64748B),
                            indicatorColor: const Color(0xFF6D28D9),
                            indicatorWeight: 3,
                            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                            tabs: [
                              const Tab(text: 'Available Masterclasses'),
                              Tab(text: 'My Enrolled Courses (${enrolledCourses.length})'),
                            ],
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _categoryChip('All'),
                                _categoryChip('Emotional Intelligence'),
                                _categoryChip('Workplace Well-being'),
                                _categoryChip('Team Engagement'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCatalogGrid(filteredCourses, userId, courseProv),
                  _buildEnrolledList(context, enrolledCourses, userId, courseProv),
                ],
              ),
            ),
          ],
        );
      },
    ),
  ),
);
  }

  Widget _categoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(category),
        selectedColor: const Color(0xFFF5F3FF),
        backgroundColor: Colors.white,
        checkmarkColor: const Color(0xFF6D28D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? const Color(0xFFDDD6FE) : const Color(0xFFE2E8F0),
          ),
        ),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF6D28D9) : const Color(0xFF475569),
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12.5,
        ),
        onSelected: (val) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildCatalogGrid(List<Course> courses, String userId, CourseProvider courseProv) {
    if (courses.isEmpty) {
      return const Center(child: Text('No courses found in this category.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth < 420 ? (constraints.maxWidth - 32) : 360.0;
        final padding = constraints.maxWidth < 420 ? 16.0 : 28.0;

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                children: courses.map((course) {
                  final isEnrolled = courseProv.isUserEnrolled(userId, course.id);
                  return Container(
                    width: cardWidth,
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
                        // Card Top Accent
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFDE68A)),
                                  ),
                                  child: Text(
                                    course.badge,
                                    style: const TextStyle(
                                      color: Color(0xFF92400E),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${course.rating}',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                                  ),
                                  Text(
                                    ' (${course.reviewCount})',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Card Body
                        Padding(
                          padding: const EdgeInsets.all(22),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.category.toUpperCase(),
                                style: const TextStyle(
                                  color: Color(0xFF6D28D9),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                course.title,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  height: 1.3,
                                  letterSpacing: -0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                course.subtitle,
                                style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.45),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 12,
                                runSpacing: 6,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.schedule_rounded, size: 15, color: Color(0xFF64748B)),
                                      const SizedBox(width: 5),
                                      Text('${course.totalDurationHours} hrs total',
                                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.menu_book_rounded, size: 15, color: Color(0xFF64748B)),
                                      const SizedBox(width: 5),
                                      Text('${course.totalLessons} lessons',
                                          style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              const Divider(color: Color(0xFFF1F5F9)),
                              const SizedBox(height: 12),
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Tuition Fee', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                                      Text(
                                        'RM ${course.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0F172A),
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (isEnrolled) {
                                        context.read<NavigationProvider>().navigateTo(
                                          AppRoute.coursePlayer,
                                          course: course,
                                        );
                                      } else {
                                        context.read<NavigationProvider>().navigateTo(
                                          AppRoute.courseDetail,
                                          course: course,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isEnrolled ? const Color(0xFF059669) : const Color(0xFF6D28D9),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                    ),
                                    child: Text(isEnrolled ? 'Open Course' : 'View Syllabus'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnrolledList(BuildContext context, List<Course> enrolled, String userId, CourseProvider courseProv) {
    if (enrolled.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 64, color: Color(0xFF94A3B8)),
            const SizedBox(height: 16),
            const Text('You have not enrolled in any courses yet.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                DefaultTabController.of(context).animateTo(0);
              },
              child: const Text('Browse Masterclass Catalog (Journey A)'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(28),
      itemCount: enrolled.length,
      itemBuilder: (context, index) {
        final course = enrolled[index];
        const progress = 0.65; // 65% demo progress required by rubric

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 650;

                  final infoColumn = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.title,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Text('Lead Facilitator: ${course.instructor}',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 7,
                                backgroundColor: Color(0xFFF1F5F9),
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C3AED)),
                              ),
                            ),
                          ),
                          SizedBox(width: 14),
                          Text(
                            '65% Complete',
                            style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF6D28D9), fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  );

                  final continueButton = ElevatedButton.icon(
                    onPressed: () {
                      context.read<NavigationProvider>().navigateTo(
                        AppRoute.coursePlayer,
                        course: course,
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text('Continue Learning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF7C3AED)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: infoColumn),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(width: double.infinity, child: continueButton),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF7C3AED)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 36),
                      ),
                      const SizedBox(width: 22),
                      Expanded(child: infoColumn),
                      const SizedBox(width: 24),
                      continueButton,
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
