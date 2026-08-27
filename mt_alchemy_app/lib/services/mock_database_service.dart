import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/product_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/organization_model.dart';
import '../models/certificate_model.dart';
import '../models/enquiry_model.dart';

class MockDatabaseService {
  static final MockDatabaseService _instance = MockDatabaseService._internal();
  factory MockDatabaseService() => _instance;
  MockDatabaseService._internal() {
    _initializeSeedData();
  }

  // Collections
  final List<UserModel> users = [];
  final List<Course> courses = [];
  final List<Product> products = [];
  final List<OrderModel> orders = [];
  final List<Organization> organizations = [];
  final List<Employee> employees = [];
  final List<Certificate> certificates = [];
  final List<CorporateEnquiry> enquiries = [];
  final Map<String, List<String>> userEnrolledCourses = {}; // userId -> courseIds
  final Map<String, Map<String, double>> courseProgress = {}; // userId -> {courseId: progress 0.0 - 1.0}

  void _initializeSeedData() {
    // 1. Seed Users with Cryptographic Password Hashes (Default: Password123!)
    users.addAll([
      UserModel(
        id: 'usr-admin-1',
        name: 'Richard Tham (Admin)',
        email: 'admin@mtalchemy.com',
        role: UserRole.superAdmin,
        gender: 'Male',
        country: 'Malaysia',
        hobbies: ['Reading', 'Leadership Coaching'],
      ),
      UserModel(
        id: 'usr-employer-1',
        name: 'Datin Serena Wong (HR Director)',
        email: 'serena@nexuscorp.com',
        role: UserRole.employer,
        gender: 'Female',
        country: 'Malaysia',
        organizationId: 'org-1',
        organizationName: 'Kaedae Nexus Corp',
        hobbies: ['Travel', 'Sports'],
      ),
      UserModel(
        id: 'usr-trainer-1',
        name: 'Dr. Marcus Vance (EQ Master Trainer)',
        email: 'marcus@mtalchemy.com',
        role: UserRole.trainer,
        gender: 'Male',
        country: 'Singapore',
        hobbies: ['Music', 'Reading', 'Travel'],
      ),
      UserModel(
        id: 'usr-learner-1',
        name: 'Alex Chen',
        email: 'alex.chen@student.com',
        role: UserRole.individual,
        gender: 'Male',
        country: 'Malaysia',
        hobbies: ['Sports', 'Music'],
      ),
    ]);

    // 2. Seed Courses
    courses.addAll([
      Course(
        id: 'course-eq-101',
        title: 'Executive Emotional Intelligence & Mindful Leadership',
        subtitle:
            'Shift from reactive management to empathetic, high-impact leadership.',
        description:
            'A signature MT Alchemy human-centered masterclass designed for leaders and emerging managers to master self-awareness, social awareness, and self-regulation.',
        category: 'Emotional Intelligence',
        instructor: 'Dr. Marcus Vance',
        price: 349.00,
        rating: 4.9,
        reviewCount: 148,
        level: 'Intermediate',
        totalDurationHours: 8,
        badge: 'Best Seller',
        learningOutcomes: [
          'Recognize emotional triggers and prevent leadership burnout',
          'Cultivate deep active listening and empathetic feedback loops',
          'Build psychological safety across cross-functional teams',
          'Navigate conflict with calm composure and strategic clarity',
        ],
        modules: [
          CourseModule(
            id: 'm1',
            title: 'Foundations of Mindful Leadership & Emotional Agility',
            lessons: [
              Lesson(
                id: 'l1-1',
                title: 'Introduction: Why EQ Outperforms Technical Skill',
                durationMinutes: 12,
                type: LessonType.video,
                contentUrl: 'https://cdn.mtalchemy.com/videos/eq-intro.mp4',
                notes:
                    'Technical skill gets you hired; emotional agility keeps you effective. In this lesson we unpack the four Goleman quadrants: Self-Awareness, Self-Management, Social Awareness, and Relationship Management.',
              ),
              Lesson(
                id: 'l1-2',
                title: 'The Neuroscience of Workplace Stress & Amygdala Hijack',
                durationMinutes: 18,
                type: LessonType.pdf,
                contentUrl: 'https://cdn.mtalchemy.com/docs/neuroscience-eq.pdf',
                notes:
                    'Review the included 14-page whitepaper on the fight-flight-freeze impulse during high-stakes corporate conversations.',
              ),
              Lesson(
                id: 'l1-3',
                title: 'Self-Awareness Reflection & Habit Audit',
                durationMinutes: 15,
                type: LessonType.video,
                contentUrl: 'https://cdn.mtalchemy.com/videos/habit-audit.mp4',
                notes:
                    'Practical daily reflection frameworks for senior managers to audit decision fatigue.',
              ),
            ],
          ),
          CourseModule(
            id: 'm2',
            title: 'Mastering Team Dynamics & Empathetic Feedback',
            lessons: [
              Lesson(
                id: 'l2-1',
                title: 'The Psychological Safety Framework in Modern Hybrid Teams',
                durationMinutes: 20,
                type: LessonType.video,
                contentUrl: 'https://cdn.mtalchemy.com/videos/psych-safety.mp4',
                notes:
                    'Learn Amy Edmondson\'s psychological safety pillars adapted for Southeast Asian workplace contexts.',
              ),
              Lesson(
                id: 'l2-2',
                title: 'Constructive Disruption: Delivering Feedback that Transforms',
                durationMinutes: 14,
                type: LessonType.pdf,
                contentUrl: 'https://cdn.mtalchemy.com/docs/feedback-matrix.pdf',
                notes:
                    'Framework: Situation-Behavior-Impact-Intention (SBII) Matrix with real roleplay transcripts.',
              ),
              Lesson(
                id: 'l2-3',
                title: 'Module 2 Mastery & Assessment Quiz',
                durationMinutes: 25,
                type: LessonType.quiz,
                contentUrl: '',
                notes:
                    'Demonstrate your grasp of empathetic communication and situational leadership.',
                quiz: Quiz(
                  id: 'quiz-eq-1',
                  title: 'Executive EQ Mastery Assessment',
                  passScore: 70,
                  questions: [
                    QuizQuestion(
                      id: 'q1',
                      questionText:
                          'What is the primary physiological reaction behind an "Amygdala Hijack" during difficult meetings?',
                      options: [
                        'The prefrontal cortex accelerates logical deduction',
                        'The limbic system triggers an immediate fight-or-flight response, bypassing rational processing',
                        'Dopamine levels spike causing euphoria',
                        'Visual cortex decreases peripheral vision only',
                      ],
                      correctOptionIndex: 1,
                      explanation:
                          'During an amygdala hijack, intense emotional stimuli override prefrontal cortex analytical faculties.',
                    ),
                    QuizQuestion(
                      id: 'q2',
                      questionText:
                          'Which component is central to fostering "Psychological Safety" in high-performing teams?',
                      options: [
                        'Zero tolerance for errors and public reprimands',
                        'Allowing team members to take interpersonal risks without fear of negative consequences',
                        'Requiring anonymous communications exclusively',
                        'Avoiding all difficult conversations',
                      ],
                      correctOptionIndex: 1,
                      explanation:
                          'Psychological safety is the shared belief that the team is safe for interpersonal risk-taking.',
                    ),
                    QuizQuestion(
                      id: 'q3',
                      questionText:
                          'According to the SBII feedback model, what does the first "I" represent?',
                      options: [
                        'Interrogation',
                        'Impact (the concrete effect on the project or team)',
                        'Instruction',
                        'Inference',
                      ],
                      correctOptionIndex: 1,
                      explanation:
                          'SBII stands for Situation, Behavior, Impact, and Intention.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Course(
        id: 'course-lead-202',
        title: 'Team Well-being: Stress Transformation & Resilience',
        subtitle: 'Build sustainable workplace energy and prevent team burnout.',
        description:
            'A practical toolkit for individuals and managers to transform high-pressure environments into hubs of psychological resilience.',
        category: 'Workplace Well-being',
        instructor: 'Sarah Jenkins, MSc',
        price: 249.00,
        rating: 4.8,
        reviewCount: 96,
        level: 'All Levels',
        totalDurationHours: 5,
        badge: 'Recommended',
        learningOutcomes: [
          'Design team energy management systems',
          'Implement daily micro-resilience practices',
          'Detect subtle signs of employee chronic exhaustion',
        ],
        modules: [
          CourseModule(
            id: 'm1-lead',
            title: 'The Science of Stress Adaptation',
            lessons: [
              Lesson(
                id: 'l-wb-1',
                title: 'Eustress vs Distress in High-Velocity Workspaces',
                durationMinutes: 15,
                type: LessonType.video,
                contentUrl: 'https://cdn.mtalchemy.com/videos/eustress.mp4',
                notes: 'Understanding how challenge stress stimulates innovation.',
              ),
            ],
          ),
        ],
      ),
      Course(
        id: 'course-teams-303',
        title: 'High-Performing Team Engagement & Culture Shift',
        subtitle:
            'Align cross-functional team habits to achieve collective flow.',
        description:
            'Focus on shifting team cultures through active experiential facilitation and habit engineering.',
        category: 'Team Engagement',
        instructor: 'Dr. Marcus Vance',
        price: 399.00,
        rating: 5.0,
        reviewCount: 88,
        level: 'Advanced',
        totalDurationHours: 10,
        badge: 'Top Rated',
        learningOutcomes: [
          'Run transformative retrospective alignment sessions',
          'Align divergent multi-generational workforce values',
        ],
        modules: [
          CourseModule(
            id: 'm1-teams',
            title: 'Culture Architecture Blueprint',
            lessons: [
              Lesson(
                id: 'l-t-1',
                title: 'Deconstructing Toxic Norms & Rebuilding Alignment',
                durationMinutes: 22,
                type: LessonType.video,
                contentUrl: 'https://cdn.mtalchemy.com/videos/culture-arch.mp4',
                notes: 'The step-by-step MT Alchemy culture recalibration blueprint.',
              ),
            ],
          ),
        ],
      ),
    ]);

    // 3. Seed Products (Digital & Physical)
    products.addAll([
      Product(
        id: 'prod-dig-1',
        name: 'The Workplace EQ Playbook (Interactive Digital Edition)',
        description:
            'A comprehensive 180-page interactive digital manual packed with emotional agility templates, one-on-one meeting scripts, and crisis communication guidelines.',
        price: 59.00,
        category: 'Digital Guides',
        type: ProductType.digital,
        rating: 4.9,
        reviewCount: 84,
        imageUrl: 'assets/images/product_playbook.png',
        digitalDownloadUrl:
            'https://downloads.mtalchemy.com/assets/EQ_Playbook_v4.2.pdf',
        badge: 'Instant PDF Download',
      ),
      Product(
        id: 'prod-dig-2',
        name: 'Mindful Leader Audio Meditation & Breathwork Series',
        description:
            'High-definition studio-recorded audio meditations specifically structured for high-pressure corporate leaders (Before Pitches, Post-Conflict Reset, Deep Sleep Recovery).',
        price: 39.00,
        category: 'Audio Series',
        type: ProductType.digital,
        rating: 4.8,
        reviewCount: 62,
        imageUrl: 'assets/images/product_audio.png',
        digitalDownloadUrl:
            'https://downloads.mtalchemy.com/assets/Mindful_Leader_AudioPack.zip',
        badge: 'MP3 Audio Pack',
      ),
      Product(
        id: 'prod-dig-3',
        name: 'Team Well-Being Pulse Diagnostic Toolkit',
        description:
            'Plug-and-play survey templates, automated score calculations in Excel/Notion, and presentation slide templates for HR leaders.',
        price: 79.00,
        category: 'Corporate Toolkits',
        type: ProductType.digital,
        rating: 4.7,
        reviewCount: 41,
        imageUrl: 'assets/images/product_toolkit.png',
        digitalDownloadUrl:
            'https://downloads.mtalchemy.com/assets/Pulse_Diagnostic_Kit.zip',
        badge: 'HR Toolkit',
      ),
      Product(
        id: 'prod-phys-1',
        name: 'MT Alchemy EQ Reflection Card Deck (52 Foil Cards)',
        description:
            'Premium 350gsm gold-foil stamped conversation and reflection cards. Ideal for team standups, 1-on-1 coaching, and executive retreats.',
        price: 89.00,
        category: 'Physical Facilitation',
        type: ProductType.physical,
        rating: 5.0,
        reviewCount: 112,
        imageUrl: 'assets/images/product_cards.png',
        stockQuantity: 42,
        badge: 'Best Seller Kit',
      ),
      Product(
        id: 'prod-phys-2',
        name: 'The Mindful Executive Handcrafted Leather Journal',
        description:
            'Italian bonded eco-leather, 100gsm bamboo paper with daily guided gratitude, focus triggers, and emotional agility reflection prompts.',
        price: 65.00,
        category: 'Stationery & Wellness',
        type: ProductType.physical,
        rating: 4.9,
        reviewCount: 57,
        imageUrl: 'assets/images/product_journal.png',
        stockQuantity: 28,
        badge: 'Premium Gift',
      ),
      Product(
        id: 'prod-phys-3',
        name: 'Team Engagement Facilitation Box Set (All-in-One)',
        description:
            'Includes 3 Card Decks, 5 Journals, Facilitator Wooden Timer, and MT Alchemy physical facilitator methodology guidebook.',
        price: 249.00,
        category: 'Physical Facilitation',
        type: ProductType.physical,
        rating: 4.9,
        reviewCount: 36,
        imageUrl: 'assets/images/product_box.png',
        stockQuantity: 15,
        badge: 'Corporate Bundle',
      ),
    ]);

    // 4. Seed Organization & Employees (Journey D)
    organizations.add(
      Organization(
        id: 'org-1',
        name: 'Kaedae Nexus Corp',
        industry: 'FinTech & Software Solutions',
        contactEmail: 'serena@nexuscorp.com',
        contactPhone: '+60 12-889 3321',
        totalSeatsPurchased: 50,
      ),
    );

    employees.addAll([
      Employee(
        id: 'emp-1',
        orgId: 'org-1',
        name: 'Daniel Lim',
        email: 'daniel.lim@nexuscorp.com',
        department: 'Engineering',
        assignedCourseIds: ['course-eq-101'],
        completedCourseIds: ['course-eq-101'],
        averageProgress: 1.0, // 100%
      ),
      Employee(
        id: 'emp-2',
        orgId: 'org-1',
        name: 'Priya Raman',
        email: 'priya.r@nexuscorp.com',
        department: 'Product Management',
        assignedCourseIds: ['course-eq-101', 'course-lead-202'],
        completedCourseIds: [],
        averageProgress: 0.65, // 65% progress requirement demo
      ),
      Employee(
        id: 'emp-3',
        orgId: 'org-1',
        name: 'Tan Kai Wen',
        email: 'kaiwen@nexuscorp.com',
        department: 'People Operations',
        assignedCourseIds: ['course-eq-101'],
        completedCourseIds: [],
        averageProgress: 0.40,
      ),
      Employee(
        id: 'emp-4',
        orgId: 'org-1',
        name: 'Nurul Huda',
        email: 'nurul.huda@nexuscorp.com',
        department: 'Customer Success',
        assignedCourseIds: ['course-teams-303'],
        completedCourseIds: [],
        averageProgress: 0.85,
      ),
    ]);

    // 5. Seed Initial User Enrollments & Progress
    userEnrolledCourses['usr-learner-1'] = ['course-eq-101'];
    courseProgress['usr-learner-1'] = {'course-eq-101': 0.65}; // 65% demo

    // 6. Seed Existing Certificate
    certificates.add(
      Certificate(
        id: 'cert-001',
        certificateNumber: 'MTA-EQ-2026-8891',
        courseId: 'course-eq-101',
        courseTitle: 'Executive Emotional Intelligence & Mindful Leadership',
        userId: 'usr-learner-1',
        userName: 'Alex Chen',
        grade: 'Distinction (94%)',
      ),
    );

    // 7. Seed Corporate Enquiries (Journey E)
    enquiries.addAll([
      CorporateEnquiry(
        id: 'enq-101',
        companyName: 'Maybank Digital Innovation Group',
        contactPerson: 'David Tan',
        email: 'david.tan@maybank.com.my',
        phone: '+60 17-234 5678',
        participantsCount: 45,
        topicsInterested: [
          'Emotional Intelligence (EQ)',
          'Leadership Development',
        ],
        deliveryMode: 'Hybrid',
        customRequirements:
            'Need a 2-day intensive retreat for newly promoted engineering managers to improve cross-functional stakeholder empathy.',
        status: EnquiryStatus.underReview,
      ),
    ]);

    // 8. Seed Orders
    orders.add(
      OrderModel(
        id: 'ORD-7821',
        userId: 'usr-learner-1',
        userEmail: 'alex.chen@student.com',
        items: [
          CartItem(
            product: products[0], // Digital playbook
            quantity: 1,
          ),
        ],
        subtotal: 59.00,
        shippingFee: 0.0,
        tax: 0.0,
        totalAmount: 59.00,
        status: OrderStatus.delivered,
        hasPhysicalItems: false,
        paymentMethod: 'FPX Online Banking',
      ),
    );
  }
}
