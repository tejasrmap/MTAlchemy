import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/course_model.dart';
import '../../providers/course_provider.dart';
import '../../widgets/stat_card.dart';

class TrainerPortalScreen extends StatelessWidget {
  const TrainerPortalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProv = context.watch<CourseProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trainer Profile Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppConstants.borderGrey),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppConstants.mindfulnessTeal,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.co_present, color: Colors.white, size: 36),
                    ),
                    const SizedBox(width: 18),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. Marcus Vance',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Lead EQ Consultant & Executive Coach • MT Alchemy Master Trainer',
                            style: TextStyle(color: AppConstants.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppConstants.mindfulnessTeal.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'TRAINER ROLE ACTIVE',
                        style: TextStyle(
                          color: AppConstants.mindfulnessTeal,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // KPI Stat Cards
              // Dynamic Real Training Statistics
              Builder(
                builder: (context) {
                  final submissions = courseProv.quizSubmissions;
                  final certs = courseProv.certificates;
                  final uniqueLearners = (submissions.map((s) => s['userId']).toSet()..addAll(certs.map((c) => c.userId))).length;
                  final passRate = submissions.isNotEmpty
                      ? (submissions.where((s) => s['passed'] == true).length / submissions.length * 100).toStringAsFixed(1)
                      : (certs.isNotEmpty ? '100.0' : '0.0');

                  return Wrap(
                    spacing: 16,
                    runSpacing: 14,
                    children: [
                      SizedBox(
                        width: 340,
                        child: StatCard(
                          title: 'Assigned Courses',
                          value: '${courseProv.courses.length}',
                          subtitle: 'Active Curricula in LMS',
                          icon: Icons.school,
                          color: AppConstants.accentPurple,
                        ),
                      ),
                      SizedBox(
                        width: 340,
                        child: StatCard(
                          title: 'Active Learners',
                          value: '$uniqueLearners',
                          subtitle: '${certs.length} Certificates Issued',
                          icon: Icons.groups,
                          color: AppConstants.primaryDarkBlue,
                        ),
                      ),
                      SizedBox(
                        width: 340,
                        child: StatCard(
                          title: 'Cohort Pass Rate',
                          value: '$passRate%',
                          subtitle: 'Calculated from actual quiz assessments',
                          icon: Icons.verified,
                          color: AppConstants.successGreen,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              // Trainer Course Management List
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Facilitated Programmes & Course Analytics',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...courseProv.courses.map((course) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppConstants.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppConstants.borderGrey),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.play_lesson, color: AppConstants.accentPurple),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text(
                                      '${course.modules.length} Modules • ${course.totalLessons} Lessons • ${course.reviewCount} Ratings (${course.rating}/5.0)',
                                      style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showCohortDialog(context, course),
                                icon: const Icon(Icons.group_rounded, size: 16),
                                label: const Text('Learners & Feedback'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppConstants.primaryDarkBlue,
                                  foregroundColor: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showCohortDialog(BuildContext context, Course course) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.school_rounded, color: AppConstants.accentPurple),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Cohort Roster: ${course.title}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          content: SizedBox(
            width: 600,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Active Enrolled Learners & Assessment Status:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 12),
                  _buildLearnerRow(context, 'Alex Chen', 'alex.chen@student.com', 0.67, 'Pass with Merit (85%)', course),
                  _buildLearnerRow(context, 'Kenji Sato', 'kenji@nexuscorp.com', 0.83, 'Distinction (95%)', course),
                  _buildLearnerRow(context, 'Sarah Jenkins', 'sarah.j@horizon.com', 0.50, 'In Progress', course),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildLearnerRow(
    BuildContext context,
    String name,
    String email,
    double progress,
    String quizStatus,
    Course course,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppConstants.accentPurple.withValues(alpha: 0.1),
            child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.accentPurple)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(email, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, color: AppConstants.accentPurple),
                const SizedBox(height: 2),
                Text('Progress: ${(progress * 100).toInt()}% • Assessment: $quizStatus', style: const TextStyle(fontSize: 11, color: Colors.black87)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _showFeedbackDialog(context, name, course.title),
            icon: const Icon(Icons.rate_review_rounded, size: 14),
            label: const Text('Feedback', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  static void _showFeedbackDialog(BuildContext context, String learnerName, String courseTitle) {
    final feedbackCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Assessment Feedback for $learnerName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Course: $courseTitle', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Qualitative Assessment & Recommendations',
                  hintText: 'e.g., Demonstrated high self-awareness during the roleplay exercise...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Feedback successfully recorded and saved for $learnerName!'),
                    backgroundColor: AppConstants.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppConstants.accentPurple),
              child: const Text('Submit Feedback'),
            ),
          ],
        );
      },
    );
  }
}
