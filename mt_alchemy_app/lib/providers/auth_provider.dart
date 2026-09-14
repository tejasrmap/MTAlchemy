import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../services/mock_database_service.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final MockDatabaseService _db = MockDatabaseService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  UserRole get currentRole => _currentUser?.role ?? UserRole.guest;

  AuthProvider() {
    // Production Authentication State: Starts as unauthenticated Guest
    _currentUser = null;
    _firebaseService.authStateChanges.listen((user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // RBAC Portal Access Checks
  bool canAccessAdmin() => _currentUser?.role == UserRole.superAdmin;
  bool canAccessTrainer() => _currentUser?.role == UserRole.trainer || _currentUser?.role == UserRole.superAdmin;
  bool canAccessEmployer() => _currentUser?.role == UserRole.employer || _currentUser?.role == UserRole.superAdmin;

  // Switch Role quickly (For examiner demonstration)
  void switchRole(UserRole newRole) {
    if (newRole == UserRole.guest) {
      _currentUser = null;
    } else {
      _currentUser = _db.users.firstWhere(
        (u) => u.role == newRole,
        orElse: () => UserModel(
          id: 'usr-${newRole.name}',
          name: '${newRole.displayName} Demo',
          email: '${newRole.name}@mtalchemy.com',
          role: newRole,
          country: 'Malaysia',
          gender: 'Male',
        ),
      );
    }
    notifyListeners();
  }

  // Register User with Email, Password & Profile Validation
  Future<bool> register({
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _firebaseService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        gender: gender,
        country: country,
        hobbies: hobbies,
        role: role,
        organizationId: organizationId,
        organizationName: organizationName,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('[firebase_auth/', '').replaceAll(']', ':');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Real Login with Cryptographic Password Verification
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '').replaceAll('[firebase_auth/', '').replaceAll(']', ':');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Forgot Password / Password Reset Token
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firebaseService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Check and update verified status
  Future<bool> checkEmailVerification() async {
    final isVerified = await _firebaseService.checkEmailVerification();
    if (_currentUser != null && _currentUser!.isEmailVerified != isVerified) {
      _currentUser = _currentUser!.copyWith(isEmailVerified: isVerified);
      notifyListeners();
    }
    return isVerified;
  }

  // Profile Update
  Future<bool> updateProfile({
    String? name,
    String? country,
    List<String>? hobbies,
  }) async {
    if (_currentUser == null) return false;
    try {
      final updated = await _firebaseService.updateUserProfile(
        userId: _currentUser!.id,
        name: name,
        country: country,
        hobbies: hobbies,
      );
      _currentUser = updated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Real Sign Out & Session Teardown
  Future<void> logout() async {
    await _firebaseService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
