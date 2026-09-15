import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/course_model.dart';
import '../models/certificate_model.dart';
import '../services/mock_database_service.dart';

class CourseProvider with ChangeNotifier {
  final MockDatabaseService _db = MockDatabaseService();
  FirebaseFirestore? _firestore;

  List<Course> get courses => List.unmodifiable(_db.courses);
  List<Certificate> get certificates => List.unmodifiable(_db.certificates);

  // Completed lessons per user: userId -> Set of lessonIds
  final Map<String, Set<String>> _completedLessons = {};
  final List<Map<String, dynamic>> _quizSubmissions = [];

  List<Map<String, dynamic>> get quizSubmissions => List.unmodifiable(_quizSubmissions);

  CourseProvider() {
    // Dynamic completed lessons: 4 of 6 lessons completed = 66.7% actual progress
    _completedLessons['usr-learner-1'] = {'l1-1', 'l1-2', 'l1-3', 'l2-1'};
    _recalculateProgress('usr-learner-1', 'course-eq-101');
    _initFirestoreSync();
  }

  Future<void> _initFirestoreSync() async {
    try {
      _firestore = FirebaseFirestore.instance;

      // 1. Sync Courses
      final snap = await _firestore!.collection('courses').get();
      if (snap.docs.isNotEmpty) {
        final cloudCourses = snap.docs.map((doc) => Course.fromMap(doc.data())).toList();
        for (final c in cloudCourses) {
          final idx = _db.courses.indexWhere((existing) => existing.id == c.id);
          if (idx >= 0) {
            _db.courses[idx] = c;
          } else {
            _db.courses.add(c);
          }
        }
      }

      // 2. Sync Enrolments
      final enrollSnap = await _firestore!.collection('enrollments').get();
      if (enrollSnap.docs.isNotEmpty) {
        for (var doc in enrollSnap.docs) {
          final uid = doc.data()['userId'] as String?;
          final cid = doc.data()['courseId'] as String?;
          if (uid != null && cid != null) {
            _db.userEnrolledCourses.putIfAbsent(uid, () => []);
            if (!_db.userEnrolledCourses[uid]!.contains(cid)) {
              _db.userEnrolledCourses[uid]!.add(cid);
            }
          }
        }
      }

      // 3. Sync Course Progress
      final progSnap = await _firestore!.collection('course_progress').get();
      if (progSnap.docs.isNotEmpty) {
        for (var doc in progSnap.docs) {
          final uid = doc.data()['userId'] as String?;
          final cid = doc.data()['courseId'] as String?;
          final List lessons = doc.data()['completedLessons'] ?? [];
          if (uid != null && cid != null) {
            _completedLessons.putIfAbsent(uid, () => {});
            _completedLessons[uid]!.addAll(lessons.map((e) => e.toString()));
            _recalculateProgress(uid, cid);
          }
        }
      }

      // 4. Sync Certificates
      final certSnap = await _firestore!.collection('certificates').get();
      if (certSnap.docs.isNotEmpty) {
        for (var doc in certSnap.docs) {
          final cert = Certificate.fromMap(doc.data());
          final idx = _db.certificates.indexWhere((c) => c.id == cert.id);
          if (idx >= 0) {
            _db.certificates[idx] = cert;
          } else {
            _db.certificates.add(cert);
          }
        }
      }

      // 5. Sync Quiz Submissions
      final quizSnap = await _firestore!.collection('quiz_submissions').get();
      if (quizSnap.docs.isNotEmpty) {
        _quizSubmissions.clear();
        for (var doc in quizSnap.docs) {
          _quizSubmissions.add(doc.data());
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('[CourseProvider] Firestore sync note: $e');
    }
  }

  void _recalculateProgress(String userId, String courseId) {
    final matches = _db.courses.where((c) => c.id == courseId);
    if (matches.isEmpty) return;
    final course = matches.first;
    final int total = course.totalLessons;
    if (total == 0) return;

    final userDone = _completedLessons[userId] ?? {};
    int count = 0;
    for (var m in course.modules) {
      for (var l in m.lessons) {
        if (userDone.contains(l.id)) count++;
      }
    }
    if (!_db.courseProgress.containsKey(userId)) {
      _db.courseProgress[userId] = {};
    }
    _db.courseProgress[userId]![courseId] = count / total;
  }

  // Check if user is enrolled
  bool isUserEnrolled(String userId, String courseId) {
    final list = _db.userEnrolledCourses[userId] ?? [];
    return list.contains(courseId);
  }

  // Access restriction guard
  bool canAccessCourse(String userId, String courseId) {
    return isUserEnrolled(userId, courseId);
  }

  // Get user's enrolled courses
  List<Course> getUserEnrolledCourses(String userId) {
    final ids = _db.userEnrolledCourses[userId] ?? [];
    return _db.courses.where((c) => ids.contains(c.id)).toList();
  }

  // Enroll in course
  void enrollCourse(String userId, String courseId) {
    if (!_db.userEnrolledCourses.containsKey(userId)) {
      _db.userEnrolledCourses[userId] = [];
    }
    if (!_db.userEnrolledCourses[userId]!.contains(courseId)) {
      _db.userEnrolledCourses[userId]!.add(courseId);
    }
    if (!_db.courseProgress.containsKey(userId)) {
      _db.courseProgress[userId] = {};
    }
    _db.courseProgress[userId]![courseId] = 0.0;
    notifyListeners();

    // Persist to Cloud Firestore
    _persistEnrollmentToFirestore(userId, courseId);
  }

  Future<void> _persistEnrollmentToFirestore(String userId, String courseId) async {
    try {
      _firestore ??= FirebaseFirestore.instance;
      await _firestore!.collection('enrollments').doc('${userId}_$courseId').set({
        'userId': userId,
        'courseId': courseId,
        'enrolledAt': FieldValue.serverTimestamp(),
        'status': 'active',
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[CourseProvider] Firestore enroll persistence note: $e');
    }
  }

  // Get progress (0.0 to 1.0)
  double getCourseProgress(String userId, String courseId) {
    return _db.courseProgress[userId]?[courseId] ?? 0.0;
  }

  // Check if a specific lesson is completed
  bool isLessonCompleted(String userId, String lessonId) {
    return _completedLessons[userId]?.contains(lessonId) ?? false;
  }

  // Mark lesson as completed
  void markLessonCompleted(String userId, String courseId, String lessonId) {
    if (!_completedLessons.containsKey(userId)) {
      _completedLessons[userId] = {};
    }
    _completedLessons[userId]!.add(lessonId);

    _recalculateProgress(userId, courseId);
    notifyListeners();

    // Persist to Cloud Firestore
    _persistProgressToFirestore(userId, courseId);
  }

  Future<void> _persistProgressToFirestore(String userId, String courseId) async {
    try {
      _firestore ??= FirebaseFirestore.instance;
      final completed = _completedLessons[userId]?.toList() ?? [];
      final progress = getCourseProgress(userId, courseId);
      await _firestore!.collection('course_progress').doc('${userId}_$courseId').set({
        'userId': userId,
        'courseId': courseId,
        'completedLessons': completed,
        'progress': progress,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[CourseProvider] Firestore progress persistence note: $e');
    }
  }

  // Record quiz result, store submission, and auto-generate certificate if passed
  Certificate? recordQuizResult({
    required String userId,
    required String userName,
    required String courseId,
    required String courseTitle,
    required int scorePercentage,
    required int passScore,
  }) {
    // Record submission to Firestore
    _recordQuizSubmission(
      userId: userId,
      userName: userName,
      courseId: courseId,
      scorePercentage: scorePercentage,
      passScore: passScore,
      passed: scorePercentage >= passScore,
    );

    if (scorePercentage >= passScore) {
      // Mark course as 100% completed
      if (!_db.courseProgress.containsKey(userId)) {
        _db.courseProgress[userId] = {};
      }
      _db.courseProgress[userId]![courseId] = 1.0;

      // Check if certificate already exists
      final existing = _db.certificates.indexWhere(
        (c) => c.userId == userId && c.courseId == courseId,
      );

      final cert = Certificate(
        id: 'cert-${DateTime.now().millisecondsSinceEpoch}',
        certificateNumber:
            'MTA-${DateTime.now().year}-${(1000 + _db.certificates.length)}',
        courseId: courseId,
        courseTitle: courseTitle,
        userId: userId,
        userName: userName,
        grade: scorePercentage >= 90
            ? 'Distinction ($scorePercentage%)'
            : 'Pass with Merit ($scorePercentage%)',
      );

      if (existing >= 0) {
        _db.certificates[existing] = cert;
      } else {
        _db.certificates.add(cert);
      }

      notifyListeners();

      // Persist certificate to Cloud Firestore
      _persistCertificateToFirestore(cert);
      _persistProgressToFirestore(userId, courseId);

      return cert;
    }
    notifyListeners();
    return null;
  }

  Future<void> _recordQuizSubmission({
    required String userId,
    required String userName,
    required String courseId,
    required int scorePercentage,
    required int passScore,
    required bool passed,
  }) async {
    final submission = {
      'userId': userId,
      'userName': userName,
      'courseId': courseId,
      'scorePercentage': scorePercentage,
      'passScore': passScore,
      'passed': passed,
      'submittedAt': DateTime.now().toIso8601String(),
    };
    _quizSubmissions.insert(0, submission);
    try {
      _firestore ??= FirebaseFirestore.instance;
      await _firestore!.collection('quiz_submissions').add({
        ...submission,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('[CourseProvider] Firestore quiz submission note: $e');
    }
  }

  Future<void> _persistCertificateToFirestore(Certificate cert) async {
    try {
      _firestore ??= FirebaseFirestore.instance;
      await _firestore!.collection('certificates').doc(cert.id).set(cert.toMap());
    } catch (e) {
      debugPrint('[CourseProvider] Firestore certificate persistence note: $e');
    }
  }

  // Certificate Verification
  Future<Certificate?> verifyCertificateOnline(String certNumber) async {
    final cleanNo = certNumber.trim().toUpperCase();
    final localMatches = _db.certificates.where((c) => c.certificateNumber.toUpperCase() == cleanNo);
    if (localMatches.isNotEmpty) return localMatches.first;

    try {
      _firestore ??= FirebaseFirestore.instance;
      final snap = await _firestore!
          .collection('certificates')
          .where('certificateNumber', isEqualTo: cleanNo)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        return Certificate.fromMap(snap.docs.first.data());
      }
    } catch (e) {
      debugPrint('[CourseProvider] Certificate verification note: $e');
    }
    return null;
  }

  // Admin CRUD Operations
  void addCourse(Course course) {
    _db.courses.add(course);
    notifyListeners();
    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('courses').doc(course.id).set(course.toMap());
    } catch (e) {
      debugPrint('[CourseProvider] Firestore course creation note: $e');
    }
  }

  void updateCourse(Course course) {
    final idx = _db.courses.indexWhere((c) => c.id == course.id);
    if (idx >= 0) {
      _db.courses[idx] = course;
      notifyListeners();
      try {
        _firestore ??= FirebaseFirestore.instance;
        _firestore!.collection('courses').doc(course.id).set(course.toMap());
      } catch (e) {
        debugPrint('[CourseProvider] Firestore course update note: $e');
      }
    }
  }

  void deleteCourse(String courseId) {
    _db.courses.removeWhere((c) => c.id == courseId);
    notifyListeners();
    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('courses').doc(courseId).delete();
    } catch (e) {
      debugPrint('[CourseProvider] Firestore course delete note: $e');
    }
  }

  // Module and Lesson Management
  void addModule(String courseId, CourseModule module) {
    final idx = _db.courses.indexWhere((c) => c.id == courseId);
    if (idx >= 0) {
      final updatedModules = List<CourseModule>.from(_db.courses[idx].modules)..add(module);
      final updated = _db.courses[idx].copyWith(modules: updatedModules);
      updateCourse(updated);
    }
  }

  void addLesson(String courseId, String moduleId, Lesson lesson) {
    final cIdx = _db.courses.indexWhere((c) => c.id == courseId);
    if (cIdx >= 0) {
      final course = _db.courses[cIdx];
      final mIdx = course.modules.indexWhere((m) => m.id == moduleId);
      if (mIdx >= 0) {
        final module = course.modules[mIdx];
        final updatedLessons = List<Lesson>.from(module.lessons)..add(lesson);
        final updatedModule = CourseModule(
          id: module.id,
          title: module.title,
          lessons: updatedLessons,
        );
        final updatedModules = List<CourseModule>.from(course.modules)..[mIdx] = updatedModule;
        final updated = course.copyWith(modules: updatedModules);
        updateCourse(updated);
      }
    }
  }
}
