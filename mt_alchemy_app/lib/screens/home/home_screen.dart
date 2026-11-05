import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/store_provider.dart';
import '../../widgets/custom_footer.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;

  const HomeScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();
    final courseProv = context.watch<CourseProvider>();
    final store = context.watch<StoreProvider>();
    final auth = context.watch<AuthProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Executive Platform Hero & Telemetry
          _buildExecutiveHero(context, nav, auth),

          // 2. Active Masterclass & Progress Tracker
          _buildActiveWorkspaceSection(context, nav, courseProv),

          // 3. The 4 Human-Capital Strategic Pillars
          _buildStrategicPillarsSection(context, nav),

          // 4. Executive Masterclass Curriculum
          _buildMasterclassCurriculumSection(context, nav, courseProv),

          // 5. Facilitation Toolkits & Executive Decks (E-Store)
          _buildExecutiveToolkitsSection(context, nav, store),

          // 6. Neural EQ Diagnostic Telemetry Showcase
          _buildDiagnosticSpotlight(context, nav),

          // 7. Corporate Transformation & Enterprise Solutions
          _buildCorporateSolutionsBanner(context, nav),

          // 8. Executive Footer
          const CustomFooter(),
        ],
      ),
    );
  }

  // 1. Executive Platform Hero
  Widget _buildExecutiveHero(BuildContext context, NavigationProvider nav, AuthProvider auth) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 750;

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(bottom: BorderSide(color: Color(0xFF334155), width: 1)),
          ),
          padding: EdgeInsets.symmetric(vertical: isMobile ? 32 : 48, horizontal: isMobile ? 16 : 20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge Pill (with Flexible text to guarantee 0 overflow on narrow mobile screens)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_outlined, color: Color(0xFF38BDF8), size: 14),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            isMobile ? 'EXECUTIVE EQ & PEOPLE DEVELOPMENT' : 'ENTERPRISE PEOPLE DEVELOPMENT & EXECUTIVE EQ',
                            style: TextStyle(
                              color: const Color(0xFF38BDF8),
                              fontSize: isMobile ? 9.5 : 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Hero Heading
                  Text(
                    auth.isAuthenticated
                        ? 'Welcome back, ${auth.currentUser?.name.split(" ").first ?? "Leader"}.\nExecutive Learning Workspace.'
                        : 'We Don\'t Just Run Activities.\nWe Shift Mindsets, Behaviours & Team Culture.',
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 34,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.8,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subheading
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 780),
                    child: Text(
                      'Transformative organizational consulting grounded in Daniel Goleman\'s Emotional Intelligence, psychological safety, and somatic workplace well-being.',
                      style: TextStyle(
                        fontSize: isMobile ? 13.5 : 16,
                        color: const Color(0xFF94A3B8),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // CTAs
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => nav.navigateTo(AppRoute.lms),
                        icon: const Icon(Icons.school_rounded, size: 18),
                        label: const Text('Explore Masterclasses'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => nav.navigateTo(AppRoute.eqDiagnostic),
                        icon: const Icon(Icons.psychology_rounded, size: 18, color: Color(0xFF38BDF8)),
                        label: const Text('Take Neural EQ Diagnostic', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF475569), width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => nav.navigateTo(AppRoute.corporate),
                        icon: const Icon(Icons.business_center_rounded, size: 18, color: Color(0xFFA78BFA)),
                        label: const Text('Corporate RFP', style: TextStyle(color: Color(0xFFCBD5E1))),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF334155), width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Live Telemetry Bar
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 12,
                      children: [
                        _telemetryMetric(Icons.auto_stories_rounded, '6 Executive Tracks', 'Curated Masterclasses'),
                        _telemetryMetric(Icons.verified_rounded, '90% Distinction Merit', 'Verified Accreditation'),
                        _telemetryMetric(Icons.inventory_2_rounded, 'Facilitation Kits', 'Physical & Digital Tools'),
                        _telemetryMetric(Icons.lock_outline_rounded, 'Zero-Trust Cloud', 'HMAC-SHA256 Encrypted'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _telemetryMetric(IconData icon, String title, String subtitle) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF38BDF8), size: 20),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                Text(subtitle, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Active Masterclass & In-Progress Learning Card
  Widget _buildActiveWorkspaceSection(BuildContext context, NavigationProvider nav, CourseProvider courseProv) {
    final auth = context.watch<AuthProvider>();
    final userId = auth.currentUser?.id ?? 'guest_learner';
    final Course? activeCourse = courseProv.courses.isNotEmpty ? courseProv.courses.first : null;
    final progress = activeCourse != null ? courseProv.getCourseProgress(userId, activeCourse.id) : 0.0;
    final isEnrolled = activeCourse != null && courseProv.isUserEnrolled(userId, activeCourse.id);

    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'CURRENT LEARNING FOCUS',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Executive Learning Workspace',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => nav.navigateTo(AppRoute.lms),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('View All Enrolments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Active Course Card
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 900;

                  final mainContent = Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFBFDBFE)),
                              ),
                              child: const Text(
                                'FLAGSHIP EXECUTIVE MASTERCLASS',
                                style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 10.5, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                isEnrolled ? 'Enrolled' : 'Available',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          activeCourse?.title ?? 'Executive Emotional Intelligence & Mindful Leadership',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activeCourse?.description ??
                              'Grounded in Daniel Goleman\'s emotional intelligence framework, psychological safety, and executive stress stewardship.',
                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),

                        // Progress Bar & Percentage
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Text(
                              'Masterclass Progress: ${(progress * 100).toInt()}% Completed',
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                            ),
                            Text(
                              '${(progress * 12).toInt()} of 12 Lessons Completed',
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress > 0 ? progress : 0.05,
                            minHeight: 8,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Actions
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                nav.navigateTo(AppRoute.lms);
                              },
                              icon: const Icon(Icons.play_circle_fill_rounded, size: 18),
                              label: Text(
                                isEnrolled ? 'Resume Masterclass' : 'Enrol in Masterclass',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => nav.navigateTo(AppRoute.eqDiagnostic),
                              icon: const Icon(Icons.assessment_outlined, size: 17),
                              label: const Text('Knowledge Assessment', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF334155),
                                side: const BorderSide(color: Color(0xFFCBD5E1)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );

                  final sideMilestoneCard = Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.workspace_premium_rounded, color: Color(0xFFF59E0B), size: 22),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Accreditation Standards',
                                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _accreditationItem('Quiz Pass Mark', '70% Minimum Threshold'),
                        const SizedBox(height: 10),
                        _accreditationItem('Executive Distinction', '90%+ Score Verification'),
                        const SizedBox(height: 10),
                        _accreditationItem('Digital Credential', 'Cryptographically Signed'),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Trusted Certificate issuance verified via Cloud Functions.',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF15803D), fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );

                  if (isNarrow) {
                    return Column(
                      children: [
                        mainContent,
                        const SizedBox(height: 16),
                        sideMilestoneCard,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: mainContent),
                      const SizedBox(width: 20),
                      Expanded(flex: 4, child: sideMilestoneCard),
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

  Widget _accreditationItem(String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 5,
          margin: const EdgeInsets.only(top: 6, right: 8),
          decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis),
              Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  // 3. The 4 Human-Capital Strategic Pillars
  Widget _buildStrategicPillarsSection(BuildContext context, NavigationProvider nav) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FOUR STRATEGIC PILLARS OF PEOPLE DEVELOPMENT',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Moving Beyond Surface-Level Team Building',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 650;
                  final isTablet = constraints.maxWidth < 1000;

                  final width = isMobile
                      ? constraints.maxWidth
                      : (isTablet ? (constraints.maxWidth - 16) / 2 : (constraints.maxWidth - 48) / 4);

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _pillarCard(
                        width: width,
                        icon: Icons.psychology_rounded,
                        color: const Color(0xFF3B82F6),
                        title: 'Emotional Intelligence',
                        subtitle: 'Daniel Goleman Model',
                        desc: 'Self-awareness, emotional regulation, empathetic resonance, and situational adaptability in high-stakes environments.',
                      ),
                      _pillarCard(
                        width: width,
                        icon: Icons.groups_rounded,
                        color: const Color(0xFF8B5CF6),
                        title: 'Leadership Coaching',
                        subtitle: 'Mindset Transformation',
                        desc: 'Transitioning managers from command-and-control operators into empathetic situational leaders who cultivate trust.',
                      ),
                      _pillarCard(
                        width: width,
                        icon: Icons.hub_rounded,
                        color: const Color(0xFF10B981),
                        title: 'Team Psychological Safety',
                        subtitle: 'Amy Edmondson Framework',
                        desc: 'Breaking organizational silos, fostering fearless candid feedback, and aligning cross-functional accountability.',
                      ),
                      _pillarCard(
                        width: width,
                        icon: Icons.spa_rounded,
                        color: const Color(0xFFF59E0B),
                        title: 'Workplace Well-being',
                        subtitle: 'Sustainable Performance',
                        desc: 'Cognitive energy stewardship, burnout prevention, and somatic techniques for sustained executive performance.',
                      ),
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

  Widget _pillarCard({
    required double width,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String desc,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.45)),
        ],
      ),
    );
  }

  // 4. Executive Masterclass Curriculum (Grid)
  Widget _buildMasterclassCurriculumSection(BuildContext context, NavigationProvider nav, CourseProvider courseProv) {
    final courses = courseProv.courses;

    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXECUTIVE CURRICULUM',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Accredited Masterclasses & Development Tracks',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => nav.navigateTo(AppRoute.lms),
                    icon: const Text('Browse All Courses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    label: const Icon(Icons.arrow_forward_rounded, size: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth < 650
                      ? 1
                      : (constraints.maxWidth < 1050 ? 2 : 3);
                  final double childAspectRatio = constraints.maxWidth < 450
                      ? 0.95
                      : (constraints.maxWidth < 650
                          ? 1.2
                          : (constraints.maxWidth < 1050 ? 1.05 : 1.15));

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final c = courses[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFF6FF),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      c.category,
                                      style: const TextStyle(
                                        color: Color(0xFF2563EB),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                                    SizedBox(width: 3),
                                    Text('4.9', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              c.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.description,
                              style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.35),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            const Divider(height: 20),
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Text(
                                  '${c.modules.length} Modules · Accredited',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    nav.navigateTo(AppRoute.lms);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F172A),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    elevation: 0,
                                  ),
                                  child: const Text('View Track', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 5. Facilitation Toolkits & Executive Decks (E-Store)
  Widget _buildExecutiveToolkitsSection(BuildContext context, NavigationProvider nav, StoreProvider store) {
    final products = store.products;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FACILITATION STORE & TOOLKITS',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Executive Facilitation Kits & Digital Playbooks',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () => nav.navigateTo(AppRoute.store),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2563EB),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text('Visit E-Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 650;
                  final width = isMobile ? constraints.maxWidth : (constraints.maxWidth - 20) / 2;

                  return Wrap(
                    spacing: 20,
                    runSpacing: 16,
                    children: products.take(2).map((p) {
                      final isDigital = p.type.name.toLowerCase() == 'digital';

                      return Container(
                        width: width,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDigital ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isDigital ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A),
                                    ),
                                  ),
                                  child: Text(
                                    isDigital ? 'DIGITAL DOWNLOAD' : 'FACILITATION KIT',
                                    style: TextStyle(
                                      color: isDigital ? const Color(0xFF065F46) : const Color(0xFF92400E),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Text(
                                  'RM ${p.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              p.description,
                              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), height: 1.4),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton.icon(
                              onPressed: () {
                                store.addToCart(p);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Added "${p.name}" to cart'),
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: const Color(0xFF0F172A),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                              label: const Text('Add to Cart', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
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

  // 6. Neural EQ Diagnostic Telemetry Showcase
  Widget _buildDiagnosticSpotlight(BuildContext context, NavigationProvider nav) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 800;

              final infoColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4338CA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'PROPRIETARY ASSESSMENT ENGINE',
                      style: TextStyle(color: Color(0xFFA5B4FC), fontSize: 10.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '5-Domain Neural EQ Diagnostic',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Evaluate your team\'s emotional agility across Self-Awareness, Self-Regulation, Motivation, Empathy, and Social Influence. Receive an instant personalized learning path.',
                    style: TextStyle(fontSize: 13.5, color: Color(0xFFC7D2FE), height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => nav.navigateTo(AppRoute.eqDiagnostic),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                    label: const Text('Launch Free EQ Assessment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF312E81),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ],
              );

              final metricsWidget = Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Telemetry Dimensions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    SizedBox(height: 12),
                    _EqDimensionPill('Self-Awareness & Somatic Trigger Recognition', 0.88),
                    _EqDimensionPill('Emotional Self-Regulation & Stress Balance', 0.82),
                    _EqDimensionPill('Empathetic Attunement & Active Listening', 0.91),
                    _EqDimensionPill('Relationship Influence & Conflict Navigation', 0.85),
                  ],
                ),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    infoColumn,
                    const SizedBox(height: 24),
                    metricsWidget,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(flex: 6, child: infoColumn),
                  const SizedBox(width: 32),
                  Expanded(flex: 5, child: metricsWidget),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // 7. Corporate Transformation & Enterprise Solutions
  Widget _buildCorporateSolutionsBanner(BuildContext context, NavigationProvider nav) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 24,
              runSpacing: 16,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FOR ENTERPRISE HR & L&D DIRECTORS',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Transform Your Organization\'s Team Culture',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Custom corporate masterclasses, executive team retreats, and organizational culture audits tailored to shift mindsets and engineer psychological safety.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.45),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => nav.navigateTo(AppRoute.corporate),
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Submit Corporate RFP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EqDimensionPill extends StatelessWidget {
  final String label;
  final double score;

  const _EqDimensionPill(this.label, this.score);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Color(0xFFE0E7FF), fontSize: 11, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text('${(score * 100).toInt()}%', style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: score,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF38BDF8)),
            ),
          ),
        ],
      ),
    );
  }
}
