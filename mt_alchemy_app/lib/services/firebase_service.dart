import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';
import '../models/user_model.dart';
import 'mock_database_service.dart';

/// Comprehensive Production Firebase Service:
/// 1. Real Firebase Core, Auth & Cloud Firestore.
/// 2. Session restoration via FirebaseAuth.instance.authStateChanges().
/// 3. Secure role management loaded strictly from Firestore documents.
/// 4. Email verification & Password Reset workflows.
/// 5. System audit logs in Firestore.
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  /// Flag set strictly by unit test suites to allow headless mock execution
  static bool isTestMode = false;

  bool _isFirebaseInitialized = false;
  String? _initializationError;
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;

  final MockDatabaseService _db = MockDatabaseService();
  UserModel? _currentUser;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  bool get isFirebaseInitialized => _isFirebaseInitialized;
  String? get initializationError => _initializationError;
  FirebaseAuth? get auth => _auth;
  FirebaseFirestore? get firestore => _firestore;
  UserModel? get currentUser => _currentUser;
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  /// Initialize Firebase using generated [DefaultFirebaseOptions]
  Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _isFirebaseInitialized = true;
      _initializationError = null;
      debugPrint('[FirebaseService] Real Firebase Core, Auth & Firestore initialized successfully.');

      // Subscribe to real Firebase Auth state changes
      _auth!.authStateChanges().listen((User? fbUser) async {
        if (fbUser != null) {
          await _restoreSession(fbUser);
        } else {
          _currentUser = null;
          _authStateController.add(null);
        }
      });

      // Synchronous/blocking seed on initialization
      await _seedInitialFirestoreDataIfEmpty();
    } catch (e) {
      _isFirebaseInitialized = false;
      _initializationError = e.toString();
      debugPrint('[FirebaseService] Cloud Firebase initialization note: $e');
    }
  }

  /// Restore user profile session strictly from Firestore (No email-based role heuristics)
  Future<void> _restoreSession(User fbUser) async {
    try {
      if (_firestore == null) return;
      final doc = await _firestore!.collection('users').doc(fbUser.uid).get();
      if (doc.exists && doc.data() != null) {
        _currentUser = UserModel.fromMap(doc.data()!);
        _authStateController.add(_currentUser);
      } else {
        // Document does not exist yet; default strictly to individual learner
        final userModel = UserModel(
          id: fbUser.uid,
          name: fbUser.displayName ?? (fbUser.email?.split('@').first ?? 'Learner'),
          email: fbUser.email ?? '',
          role: UserRole.individual,
          isEmailVerified: fbUser.emailVerified,
        );
        await _firestore!.collection('users').doc(fbUser.uid).set(userModel.toFirestore());
        _currentUser = userModel;
        _authStateController.add(_currentUser);
      }
    } catch (e) {
      debugPrint('[FirebaseService] Restore session note: $e');
    }
  }

  /// Automatically populate Firestore collections if they are empty
  Future<void> _seedInitialFirestoreDataIfEmpty() async {
    try {
      if (_firestore == null) return;
      final snap = await _firestore!.collection('courses').limit(1).get();
      if (snap.docs.isEmpty) {
        for (final course in _db.courses) {
          await _firestore!.collection('courses').doc(course.id).set(course.toMap());
        }
        for (final product in _db.products) {
          await _firestore!.collection('products').doc(product.id).set(product.toMap());
        }
        for (final org in _db.organizations) {
          await _firestore!.collection('organizations').doc(org.id).set(org.toMap());
        }
        for (final emp in _db.employees) {
          await _firestore!.collection('employees').doc(emp.id).set(emp.toMap());
        }
        for (final user in _db.users) {
          await _firestore!.collection('users').doc(user.id).set(user.toFirestore());
        }
        debugPrint('[FirebaseService] Cloud Firestore seeded with initial catalog, inventory, organizations, and user roles.');
      }
    } catch (e) {
      debugPrint('[FirebaseService] Cloud Firestore auto-seed note: $e');
    }
  }

  /// 1. Registration with Validation & Firebase Auth
  Future<UserModel> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String gender,
    required String country,
    required List<String> hobbies,
    UserRole role = UserRole.individual,
    String? organizationId,
    String? organizationName,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    // Field validations
    if (cleanEmail.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(cleanEmail)) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'The email address is badly formatted.',
      );
    }
    if (password.length < 6) {
      throw FirebaseAuthException(
        code: 'weak-password',
        message: 'The password must be at least 6 characters long.',
      );
    }

    // Role Security: Prevent regular self-registration as Super Admin, Trainer, or Employer
    if (role != UserRole.individual) {
      throw FirebaseAuthException(
        code: 'admin-role-denied',
        message: 'Security Violation: Privileged roles cannot be created via standard public registration.',
      );
    }

    // Attempt Cloud Firebase Auth if active
    if (_isFirebaseInitialized && _auth != null && _firestore != null) {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      final uid = credential.user?.uid ?? 'usr-${DateTime.now().millisecondsSinceEpoch}';

      // Send email verification
      try {
        await credential.user?.sendEmailVerification();
      } catch (_) {}

      final userModel = UserModel(
        id: uid,
        name: name.trim(),
        email: cleanEmail,
        role: UserRole.individual, // Strictly enforce individual learner
        gender: gender,
        country: country,
        hobbies: hobbies,
        organizationId: organizationId,
        organizationName: organizationName,
        isEmailVerified: false,
      );

      // Persist profile to Cloud Firestore 'users' collection without password credentials
      await _firestore!.collection('users').doc(uid).set(userModel.toFirestore());

      // Write security audit log
      logAuditEvent(
        action: 'USER_REGISTERED',
        details: 'User registered account for $cleanEmail with role individual.',
        userId: uid,
      );

      _currentUser = userModel;
      _authStateController.add(_currentUser);
      return userModel;
    }

    // Strictly forbid mock fallback in production
    if (!isTestMode) {
      throw FirebaseAuthException(
        code: 'service-unavailable',
        message: 'Production Firebase service is offline. ${_initializationError ?? "Please verify your network connection."}',
      );
    }

    // Resilient local test harness mode (restricted strictly to headless unit tests)
    final exists = _db.users.any((u) => u.email.toLowerCase() == cleanEmail);
    if (exists) {
      throw FirebaseAuthException(
        code: 'email-already-in-use',
        message: 'The email address is already in use by another account.',
      );
    }

    final newUser = UserModel(
      id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: cleanEmail,
      role: role,
      gender: gender,
      country: country,
      hobbies: hobbies,
      organizationId: organizationId,
      organizationName: organizationName,
      isEmailVerified: true,
    );

    _db.users.add(newUser);
    _currentUser = newUser;
    _authStateController.add(_currentUser);
    return newUser;
  }

  /// 2. Login with Firebase Auth
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();

    if (cleanEmail.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Please provide a valid email address.',
      );
    }

    // Real Firebase Auth
    if (_isFirebaseInitialized && _auth != null && _firestore != null) {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );
      final uid = credential.user!.uid;

      // Enforce email verification in production Firebase
      if (!credential.user!.emailVerified) {
        logAuditEvent(
          action: 'LOGIN_UNVERIFIED_EMAIL',
          details: 'User $cleanEmail attempted login with unverified email.',
          userId: uid,
        );
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email verification required. Please click the verification link sent to $cleanEmail before signing in.',
        );
      }

      // Retrieve user profile strictly from Cloud Firestore
      final doc = await _firestore!.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!);
        _currentUser = user;
        _authStateController.add(_currentUser);

        logAuditEvent(
          action: 'USER_LOGIN',
          details: 'User logged in: $cleanEmail as ${user.role.name}.',
          userId: uid,
        );

        return user;
      } else {
        final user = UserModel(
          id: uid,
          name: credential.user!.displayName ?? cleanEmail.split('@').first,
          email: cleanEmail,
          role: UserRole.individual,
          isEmailVerified: credential.user!.emailVerified,
        );
        await _firestore!.collection('users').doc(uid).set(user.toFirestore());
        _currentUser = user;
        _authStateController.add(_currentUser);
        return user;
      }
    }

    // Strictly forbid mock fallback in production
    if (!isTestMode) {
      throw FirebaseAuthException(
        code: 'service-unavailable',
        message: 'Production Firebase service is offline. No mock authentication permitted.',
      );
    }

    // Headless unit-test mock verification
    final matchingUsers = _db.users.where((u) => u.email.toLowerCase() == cleanEmail).toList();
    if (matchingUsers.isEmpty) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user record found corresponding to "$cleanEmail".',
      );
    }

    if (password.startsWith('Incorrect') || password == 'wrong') {
      throw FirebaseAuthException(
        code: 'wrong-password',
        message: 'Invalid password. Authentication failed for "$cleanEmail".',
      );
    }

    final user = matchingUsers.first;
    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  /// 3. Sign Out & Session Teardown
  Future<void> signOut() async {
    if (_isFirebaseInitialized && _auth != null) {
      try {
        await _auth!.signOut();
      } catch (_) {}
    }
    _currentUser = null;
    _authStateController.add(null);
  }

  /// 4. Forgot Password & Password Reset Verification
  Future<void> sendPasswordResetEmail(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (_isFirebaseInitialized && _auth != null) {
      await _auth!.sendPasswordResetEmail(email: cleanEmail);
      return;
    }

    if (!isTestMode) {
      throw FirebaseAuthException(
        code: 'service-unavailable',
        message: 'Production Firebase Authentication is offline. Password reset unavailable.',
      );
    }

    final exists = _db.users.any((u) => u.email.toLowerCase() == cleanEmail);
    if (!exists) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No registered user exists with that email address.',
      );
    }
    debugPrint('[FirebaseService] Password reset dispatched to $cleanEmail');
  }

  /// 5. Trigger Email Verification
  Future<void> sendEmailVerification() async {
    if (_isFirebaseInitialized && _auth != null && _auth!.currentUser != null) {
      try {
        await _auth!.currentUser!.sendEmailVerification();
      } catch (e) {
        debugPrint('[FirebaseService] sendEmailVerification error: $e');
        rethrow;
      }
    } else if (!isTestMode) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'Cannot send verification email: User is not currently authenticated.',
      );
    }
  }

  /// Check and update email verification status from Firebase Auth
  Future<bool> checkEmailVerification() async {
    if (_isFirebaseInitialized && _auth != null && _auth!.currentUser != null) {
      try {
        await _auth!.currentUser!.reload();
        final isVerified = _auth!.currentUser!.emailVerified;
        if (_currentUser != null && _currentUser!.isEmailVerified != isVerified) {
          _currentUser = _currentUser!.copyWith(isEmailVerified: isVerified);
          if (_firestore != null) {
            await _firestore!.collection('users').doc(_currentUser!.id).update({
              'isEmailVerified': isVerified,
            });
          }
          _authStateController.add(_currentUser);
        }
        return isVerified;
      } catch (e) {
        debugPrint('[FirebaseService] checkEmailVerification error: $e');
        rethrow;
      }
    }
    return _currentUser?.isEmailVerified ?? false;
  }

  /// 6. Update User Profile in Firestore
  Future<UserModel> updateUserProfile({
    required String userId,
    String? name,
    String? country,
    List<String>? hobbies,
  }) async {
    if (_currentUser == null || _currentUser!.id != userId) {
      throw Exception('Unauthorized profile update attempt.');
    }

    final updated = _currentUser!.copyWith(
      name: name,
      country: country,
      hobbies: hobbies,
    );

    // Strictly await Firestore write before updating local state
    if (_isFirebaseInitialized && _firestore != null) {
      await _firestore!.collection('users').doc(userId).update(updated.toFirestore());
    } else if (!isTestMode) {
      throw Exception('Cloud Firestore unavailable. Profile update rejected.');
    }

    // Only update memory after Firestore confirmation
    final index = _db.users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _db.users[index] = updated;
    }
    _currentUser = updated;
    _authStateController.add(_currentUser);
    return updated;
  }

  /// 7. Secure Audit Logging in Firestore
  Future<void> logAuditEvent({
    required String action,
    required String details,
    String? userId,
  }) async {
    try {
      if (_firestore == null) return;
      await _firestore!.collection('audit_logs').add({
        'action': action,
        'details': details,
        'userId': userId ?? _currentUser?.id ?? 'system',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('[FirebaseService] Audit log note: $e');
    }
  }
}
