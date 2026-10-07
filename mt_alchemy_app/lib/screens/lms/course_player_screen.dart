import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/navigation_provider.dart';

class CoursePlayerScreen extends StatefulWidget {
  final Course course;

  const CoursePlayerScreen({super.key, required this.course});

  @override
  State<CoursePlayerScreen> createState() => _CoursePlayerScreenState();
}

class _CoursePlayerScreenState extends State<CoursePlayerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentModuleIndex = 0;
  int _currentLessonIndex = 0;
  bool _isVideoPlaying = false;

  // Quiz state
  final Map<int, int> _selectedAnswers = {};
  bool _quizSubmitted = false;
  int _quizScore = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Lesson get currentLesson {
    final module = widget.course.modules[_currentModuleIndex];
    return module.lessons[_currentLessonIndex];
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final courseProv = context.watch<CourseProvider>();
    final nav = context.read<NavigationProvider>();
    final userId = auth.currentUser?.id ?? 'usr-learner-1';
    final userName = auth.currentUser?.name ?? 'Alex Chen';

    final double currentProgress = courseProv.getCourseProgress(userId, widget.course.id);
    final isCompleted = courseProv.isLessonCompleted(userId, currentLesson.id);

    return Column(
      children: [
        // Top Player Navigation & Title Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    tooltip: 'Back to Catalog',
                    onPressed: () => nav.navigateTo(AppRoute.lms),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.title,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'Module ${_currentModuleIndex + 1}: ${widget.course.modules[_currentModuleIndex].title}',
                        style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: currentProgress >= 0.65 ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: currentProgress >= 0.65 ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      currentProgress >= 0.65 ? Icons.check_circle_rounded : Icons.trending_up,
                      color: currentProgress >= 0.65 ? const Color(0xFF065F46) : const Color(0xFF92400E),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Actual Progress: ${(currentProgress * 100).toInt()}%${currentProgress >= 0.65 ? " (Benchmark Passed)" : ""}',
                      style: TextStyle(
                        color: currentProgress >= 0.65 ? const Color(0xFF065F46) : const Color(0xFF92400E),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // 1. Dynamic Course Progress Indicator
        Container(
          color: const Color(0xFFF8FAFC),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Overall Course Progress Indicator',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5, color: Color(0xFF475569)),
                  ),
                  Text(
                    '${(currentProgress * 100).toInt()}% Completed',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D28D9),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: currentProgress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6D28D9)),
                ),
              ),
            ],
          ),
        ),

        // 2. Tab Bar for Modular Design: Video, PDF, Quiz
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF6D28D9),
            unselectedLabelColor: const Color(0xFF64748B),
            indicatorColor: const Color(0xFF6D28D9),
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
            tabs: const [
              Tab(icon: Icon(Icons.play_circle_outline, size: 18), text: 'Video Lesson'),
              Tab(icon: Icon(Icons.picture_as_pdf_outlined, size: 18), text: 'Executive PDF Notes'),
              Tab(icon: Icon(Icons.quiz_outlined, size: 18), text: 'Assessment Quiz'),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),

        // 3. Tab Bar View Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildVideoTab(),
              _buildPdfTab(),
              _buildQuizTab(userId, userName, courseProv, nav),
            ],
          ),
        ),

        // 4. Navigation Controls (Previous, Mark Complete, Next buttons)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: _hasPreviousLesson() ? () => _goToPreviousLesson() : null,
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Previous'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  courseProv.markLessonCompleted(userId, widget.course.id, currentLesson.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Marked "${currentLesson.title}" as complete! Progress updated.'),
                      backgroundColor: const Color(0xFF059669),
                    ),
                  );
                },
                icon: Icon(
                  isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(isCompleted ? 'Completed' : 'Mark Complete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? const Color(0xFF059669) : const Color(0xFF6D28D9),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _hasNextLesson() ? () => _goToNextLesson() : null,
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 380,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 64,
                          icon: Icon(
                            _isVideoPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                            color: const Color(0xFFFBBF24),
                          ),
                          onPressed: () {
                            setState(() {
                              _isVideoPlaying = !_isVideoPlaying;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isVideoPlaying ? 'Playing: ${currentLesson.title}' : 'Click to Play High-Definition Video',
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 12,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          const Text('04:15', style: TextStyle(color: Colors.white, fontSize: 12)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbColor: const Color(0xFFFBBF24),
                                activeTrackColor: const Color(0xFF7C3AED),
                                inactiveTrackColor: Colors.white24,
                                trackHeight: 3,
                              ),
                              child: Slider(
                                value: 0.35,
                                onChanged: (val) {},
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('${currentLesson.durationMinutes}:00',
                              style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                currentLesson.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: AppConstants.textSecondary),
                  const SizedBox(width: 4),
                  Text(widget.course.instructor, style: const TextStyle(color: AppConstants.textSecondary)),
                  const SizedBox(width: 16),
                  const Icon(Icons.timer, size: 16, color: AppConstants.textSecondary),
                  const SizedBox(width: 4),
                  Text('${currentLesson.durationMinutes} minutes', style: const TextStyle(color: AppConstants.textSecondary)),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'Session Key Takeaways & Executive Notes:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                currentLesson.notes,
                style: const TextStyle(fontSize: 14, height: 1.6, color: AppConstants.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPdfTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${currentLesson.title} - Participant Guidebook',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Official MT Alchemy Material • 14 Pages • PDF (2.4 MB)',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Downloading Executive PDF Reader Guide...'),
                            backgroundColor: Color(0xFF0F172A),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Download PDF'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Document Preview / Key Executive Excerpt:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  'EXECUTIVE SUMMARY:\n\n'
                  'Emotional Intelligence in fast-paced corporate environments hinges on psychological micro-moments. '
                  'When leaders pause before responding to acute operational bottlenecks, they deactivate amygdala distress '
                  'and reactivate systemic problem-solving. This document synthesizes the SBII (Situation-Behavior-Impact-Intention) '
                  'matrix into repeatable 5-minute reflection protocols for daily team standups.',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 15,
                    height: 1.8,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizTab(
    String userId,
    String userName,
    CourseProvider courseProv,
    NavigationProvider nav,
  ) {
    final quiz = widget.course.modules.last.lessons.last.quiz;
    if (quiz == null) {
      return const Center(child: Text('No quiz associated with this lesson.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    quiz.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Passing Score: ${quiz.passScore}%',
                      style: const TextStyle(color: Color(0xFF6D28D9), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(quiz.questions.length, (qIndex) {
                final q = quiz.questions[qIndex];
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question ${qIndex + 1}: ${q.questionText}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(q.options.length, (optIndex) {
                        return RadioListTile<int>(
                          value: optIndex,
                          groupValue: _selectedAnswers[qIndex],
                          title: Text(q.options[optIndex], style: const TextStyle(fontSize: 14)),
                          onChanged: _quizSubmitted
                              ? null
                              : (val) {
                                  setState(() {
                                    _selectedAnswers[qIndex] = val!;
                                  });
                                },
                        );
                      }),
                      if (_quizSubmitted) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _selectedAnswers[qIndex] == q.correctOptionIndex
                                ? const Color(0xFFF0FDF4)
                                : const Color(0xFFFEF2F2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _selectedAnswers[qIndex] == q.correctOptionIndex
                                ? '✓ Correct! ${q.explanation}'
                                : '✗ Incorrect. ${q.explanation}',
                            style: TextStyle(
                              color: _selectedAnswers[qIndex] == q.correctOptionIndex
                                  ? const Color(0xFF166534)
                                  : const Color(0xFF991B1B),
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              if (!_quizSubmitted)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_selectedAnswers.length < quiz.questions.length) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please answer all questions before submitting.')),
                        );
                        return;
                      }
                      int correct = 0;
                      for (int i = 0; i < quiz.questions.length; i++) {
                        if (_selectedAnswers[i] == quiz.questions[i].correctOptionIndex) {
                          correct++;
                        }
                      }
                      final scorePct = ((correct / quiz.questions.length) * 100).round();
                      setState(() {
                        _quizSubmitted = true;
                        _quizScore = scorePct;
                      });

                      final cert = courseProv.recordQuizResult(
                        userId: userId,
                        userName: userName,
                        courseId: widget.course.id,
                        courseTitle: widget.course.title,
                        scorePercentage: scorePct,
                        passScore: quiz.passScore,
                      );

                      if (cert != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Congratulations! Passed with $scorePct%. Certificate Awarded!'),
                            backgroundColor: const Color(0xFF059669),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Submit Assessment Quiz'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D28D9),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                )
              else ...[
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _quizScore >= quiz.passScore ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _quizScore >= quiz.passScore ? const Color(0xFF86EFAC) : const Color(0xFFFCA5A5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _quizScore >= quiz.passScore ? Icons.check_circle_rounded : Icons.error_rounded,
                        color: _quizScore >= quiz.passScore ? const Color(0xFF166534) : const Color(0xFF991B1B),
                        size: 36,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _quizScore >= quiz.passScore
                                  ? 'Assessment Passed! Score: $_quizScore%'
                                  : 'Score: $_quizScore% (Passing Score: ${quiz.passScore}%)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              _quizScore >= quiz.passScore
                                  ? 'You have fulfilled all learning outcomes for this executive programme.'
                                  : 'Please review the video and notes, then retake the quiz.',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      if (_quizScore >= quiz.passScore)
                        ElevatedButton(
                          onPressed: () {
                            final cert = courseProv.certificates.firstWhere(
                              (c) => c.courseId == widget.course.id,
                            );
                            nav.navigateTo(AppRoute.certificate, certificate: cert);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                          child: const Text('View Certificate'),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool _hasPreviousLesson() {
    return _currentLessonIndex > 0 || _currentModuleIndex > 0;
  }

  bool _hasNextLesson() {
    final currentMod = widget.course.modules[_currentModuleIndex];
    if (_currentLessonIndex < currentMod.lessons.length - 1) return true;
    if (_currentModuleIndex < widget.course.modules.length - 1) return true;
    return false;
  }

  void _goToPreviousLesson() {
    setState(() {
      if (_currentLessonIndex > 0) {
        _currentLessonIndex--;
      } else if (_currentModuleIndex > 0) {
        _currentModuleIndex--;
        _currentLessonIndex = widget.course.modules[_currentModuleIndex].lessons.length - 1;
      }
    });
  }

  void _goToNextLesson() {
    final currentMod = widget.course.modules[_currentModuleIndex];
    setState(() {
      if (_currentLessonIndex < currentMod.lessons.length - 1) {
        _currentLessonIndex++;
      } else if (_currentModuleIndex < widget.course.modules.length - 1) {
        _currentModuleIndex++;
        _currentLessonIndex = 0;
      }
    });
  }
}
