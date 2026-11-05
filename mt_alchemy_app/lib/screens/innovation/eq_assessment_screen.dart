import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EqAssessmentScreen extends StatefulWidget {
  final Function(int)? onNavigateToCourse;

  const EqAssessmentScreen({super.key, this.onNavigateToCourse});

  @override
  State<EqAssessmentScreen> createState() => _EqAssessmentScreenState();
}

class _EqAssessmentScreenState extends State<EqAssessmentScreen> {
  final Map<int, int> _scores = {
    0: 4, // Self-Awareness
    1: 3, // Self-Regulation
    2: 4, // Empathetic Attunement
    3: 4, // Relationship Agility
    4: 3, // Workplace Mindfulness
  };

  bool _evaluated = false;
  List<Map<String, dynamic>> _assessmentHistory = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'dimension': 'Self-Awareness',
      'icon': Icons.visibility_rounded,
      'color': Color(0xFF6366F1),
      'prompt': 'I accurately recognize emotional triggers and bodily stress signals before reacting verbally in tense scenarios.',
      'description': 'Measures interoceptive awareness and real-time monitoring of physiological emotional spikes.',
    },
    {
      'dimension': 'Self-Regulation',
      'icon': Icons.tune_rounded,
      'color': Color(0xFF8B5CF6),
      'prompt': 'Under acute deadline pressure or organizational ambiguity, I pause emotional reactivity and choose intentional responses.',
      'description': 'Evaluates executive prefrontal inhibition, amygdala pause, and emotional impulse mastery.',
    },
    {
      'dimension': 'Empathetic Attunement',
      'icon': Icons.hearing_rounded,
      'color': Color(0xFF0D9488),
      'prompt': 'I actively listen for subtext and unvoiced team anxieties without immediately prescribing solutions or judgment.',
      'description': 'Measures interpersonal resonance, emotional attunement, and psychological safety creation.',
    },
    {
      'dimension': 'Relationship Agility',
      'icon': Icons.hub_rounded,
      'color': Color(0xFF3B82F6),
      'prompt': 'I facilitate constructive conflict resolution, align divergent perspectives, and foster authentic collaboration.',
      'description': 'Measures collaborative diplomacy, coalition building, and systemic team trust engineering.',
    },
    {
      'dimension': 'Workplace Mindfulness',
      'icon': Icons.spa_rounded,
      'color': Color(0xFF10B981),
      'prompt': 'I maintain deliberate micro-recovery routines (somatic breathing, cognitive reset) to protect sustainable team energy.',
      'description': 'Quantifies energy stewardship, burnout prevention, and nervous system recalibration.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final auth = context.read<AuthProvider>();
      if (!auth.isAuthenticated) return;
      final snap = await FirebaseFirestore.instance
          .collection('eq_assessments')
          .where('userId', isEqualTo: auth.currentUser!.id)
          .limit(5)
          .get();
      if (snap.docs.isNotEmpty) {
        setState(() {
          _assessmentHistory = snap.docs.map((d) => d.data()).toList();
        });
      }
    } catch (e) {
      debugPrint('[EQAssessment] History load note: $e');
    }
  }

  Future<void> _persistAssessment(int totalScore, int percentage, String category) async {
    try {
      final auth = context.read<AuthProvider>();
      final userId = auth.currentUser?.id ?? 'guest-learner';
      final email = auth.currentUser?.email ?? 'guest@mtalchemy.com';

      final assessmentDoc = {
        'userId': userId,
        'userEmail': email,
        'totalScore': totalScore,
        'percentage': percentage,
        'category': category,
        'dimensionScores': _scores.map((k, v) => MapEntry(k.toString(), v)),
        'evaluatedAt': DateTime.now().toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('eq_assessments').add(assessmentDoc);
      _loadHistory();
    } catch (e) {
      debugPrint('[EQAssessment] Save note: $e');
    }
  }

  String _getRatingLabel(int score) {
    switch (score) {
      case 1:
        return 'DEVELOPING';
      case 2:
        return 'EMERGING';
      case 3:
        return 'COMPETENT';
      case 4:
        return 'ADVANCED';
      case 5:
        return 'MASTERY';
      default:
        return 'COMPETENT';
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalScore = _scores.values.fold(0, (acc, val) => acc + val);
    int percentage = ((totalScore / (_questions.length * 5)) * 100).round();
    final category = percentage >= 80 ? 'EMPATHIC LEADER' : 'GROWING PRACTITIONER';

    // Find lowest dimension
    int minIdx = 0;
    int minScore = 5;
    _scores.forEach((idx, score) {
      if (score < minScore) {
        minScore = score;
        minIdx = idx;
      }
    });

    final weakDimension = _questions[minIdx]['dimension'] as String;
    String recCourseTitle = 'Executive Emotional Intelligence & Mindful Leadership';
    if (minIdx == 2 || minIdx == 3) {
      recCourseTitle = 'High-Performing Team Engagement & Culture Shift';
    } else if (minIdx == 4) {
      recCourseTitle = 'Team Well-being: Stress Transformation & Resilience';
    }

    return Container(
      color: const Color(0xFFF8FAFC),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. High-Tech Executive Banner
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0F172A),
                        Color(0xFF1E1B4B),
                        Color(0xFF31104B),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFF4338CA).withValues(alpha: 0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4338CA).withValues(alpha: 0.25),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFBBF24).withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.psychology_rounded, color: Color(0xFF0F172A), size: 34),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 10,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.fiber_manual_record, color: Color(0xFF34D399), size: 8),
                                      SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          'DIAGNOSTIC ENGINE ACTIVE',
                                          style: TextStyle(
                                            color: Color(0xFF34D399),
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.6,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Text(
                                  'NEURAL EQ TELEMETRY',
                                  style: TextStyle(
                                    color: Color(0xFFA5B4FC),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Proprietary 5-Domain Emotional Intelligence Diagnostic',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Grounded in Daniel Goleman neuroscience. Evaluates executive presence, stress resilience, empathetic attunement & team agility.',
                              style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 2. High-Tech Diagnostic Questions Deck
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Diagnostic Dimension Calibration',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F172A),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Adjust the telemetry sliders to reflect authentic leadership behaviour (1 = Rarely, 5 = Consistently).',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'CURRENT INDEX: $totalScore / 25',
                              style: const TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Questions Items
                      ...List.generate(_questions.length, (idx) {
                        final item = _questions[idx];
                        final score = _scores[idx] ?? 3;
                        final color = item['color'] as Color;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: color.withValues(alpha: 0.25),
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                runSpacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(item['icon'] as IconData, color: color, size: 18),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: Text(
                                          item['dimension'] as String,
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            letterSpacing: -0.2,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: color.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            _getRatingLabel(score),
                                            style: TextStyle(
                                              color: color,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.4,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          '$score / 5',
                                          style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['prompt'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.5,
                                  color: Color(0xFF0F172A),
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['description'] as String,
                                style: const TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: color,
                                  inactiveTrackColor: const Color(0xFFE2E8F0),
                                  thumbColor: color,
                                  overlayColor: color.withValues(alpha: 0.15),
                                  trackHeight: 6,
                                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
                                ),
                                child: Slider(
                                  value: score.toDouble(),
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  onChanged: (val) {
                                    setState(() {
                                      _scores[idx] = val.toInt();
                                      _evaluated = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _evaluated = true;
                            });
                            _persistAssessment(totalScore, percentage, category);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Diagnostic Telemetry Computed & Synced to Cloud!'),
                                backgroundColor: Color(0xFF10B981),
                              ),
                            );
                          },
                          icon: const Icon(Icons.insights_rounded, size: 20),
                          label: const Text('SYNTHESIZE EXECUTIVE EQ TELEMETRY'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F172A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                            elevation: 4,
                            shadowColor: const Color(0xFF0F172A).withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. High-Tech Diagnostic Results Telemetry Console
                if (_evaluated) ...[
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF6366F1), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                        color: const Color(0xFFEEF2FF),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: const Color(0xFFC7D2FE)),
                                      ),
                                      child: const Text(
                                        'DIAGNOSTIC REPORT',
                                        style: TextStyle(
                                          color: Color(0xFF4338CA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'ID: MTA-EQ-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Executive Emotional Agility Index',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF0F172A),
                                    letterSpacing: -0.4,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: percentage >= 80 ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: percentage >= 80 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    percentage >= 80 ? Icons.verified_rounded : Icons.trending_up_rounded,
                                    color: percentage >= 80 ? const Color(0xFF059669) : const Color(0xFFD97706),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      color: percentage >= 80 ? const Color(0xFF059669) : const Color(0xFFD97706),
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Metric Counter Row
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('TOTAL SCORE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text('$totalScore / 25', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('AGILITY PERCENTILE', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text('$percentage%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF6366F1))),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('NEURAL STATUS', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(
                                      percentage >= 80 ? 'HIGH COHESION' : 'GROWTH PHASE',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: percentage >= 80 ? const Color(0xFF059669) : const Color(0xFFD97706),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Dimension Breakdown Telemetry Bars
                        const Text(
                          'DIMENSION TELEMETRY BREAKDOWN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF475569),
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...List.generate(_questions.length, (idx) {
                          final score = _scores[idx] ?? 3;
                          final pct = score / 5.0;
                          final color = _questions[idx]['color'] as Color;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _questions[idx]['dimension'] as String,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                                    ),
                                    Text(
                                      '$score / 5 (${(pct * 100).round()}%)',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    minHeight: 8,
                                    backgroundColor: const Color(0xFFF1F5F9),
                                    valueColor: AlwaysStoppedAnimation<Color>(color),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),

                        // Personalized AI Masterclass Prescription
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFC4B5FD)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7C3AED),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PRESCRIBED EXECUTIVE MASTERCLASS',
                                          style: TextStyle(
                                            color: Color(0xFF6D28D9),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 0.6,
                                          ),
                                        ),
                                        Text(
                                          'Tailored Neuro-Leadership Intervention',
                                          style: TextStyle(
                                            color: Color(0xFF0F172A),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Based on your diagnostic telemetry, your primary growth vector is "$weakDimension". Enrolling in "$recCourseTitle" will cultivate behavioral neural pathways, stress agility, and authentic empathy.',
                                style: const TextStyle(fontSize: 13.5, color: Color(0xFF334155), height: 1.45),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: () => widget.onNavigateToCourse?.call(1),
                                icon: const Icon(Icons.rocket_launch_rounded, size: 18),
                                label: const Text('ENROL IN PRESCRIBED MASTERCLASS'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7C3AED),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // 4. Diagnostic Telemetry History Stream
                if (_assessmentHistory.isNotEmpty) ...[
                  const SizedBox(height: 36),
                  const Text(
                    'HISTORICAL DIAGNOSTIC TELEMETRY LOGS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF475569),
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._assessmentHistory.map((hist) {
                    final p = hist['percentage'] ?? 0;
                    final isHigh = p >= 80;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isHigh ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isHigh ? Icons.check_circle_rounded : Icons.pending_rounded,
                              color: isHigh ? const Color(0xFF059669) : const Color(0xFFD97706),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Score: ${hist['totalScore']} / 25 ($p%) • ${hist['category']}',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Evaluated on ${hist['evaluatedAt']?.toString().split('T').first ?? ''}',
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$p% AGILITY',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
