import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/organization_model.dart';
import '../services/mock_database_service.dart';

class EmployerProvider with ChangeNotifier {
  final MockDatabaseService _db = MockDatabaseService();
  FirebaseFirestore? _firestore;
  String? _currentOrgId;

  void setOrganizationId(String? orgId) {
    if (_currentOrgId != orgId) {
      _currentOrgId = orgId;
      notifyListeners();
    }
  }

  // Isolated Organization for active employer session
  Organization get organization {
    if (_currentOrgId != null) {
      return _db.organizations.firstWhere(
        (o) => o.id == _currentOrgId,
        orElse: () => _db.organizations.first,
      );
    }
    return _db.organizations.first;
  }

  List<Organization> get allOrganizations => List.unmodifiable(_db.organizations);

  // Isolated employee roster: Strictly filtered to current organization
  List<Employee> get employees {
    final activeOrgId = organization.id;
    return _db.employees.where((e) => e.orgId == activeOrgId).toList();
  }

  EmployerProvider() {
    _initFirestoreSync();
  }

  Future<void> _initFirestoreSync() async {
    try {
      _firestore = FirebaseFirestore.instance;
      final orgSnap = await _firestore!.collection('organizations').get();
      if (orgSnap.docs.isNotEmpty) {
        final cloudOrgs = orgSnap.docs.map((d) => Organization.fromMap(d.data())).toList();
        for (final org in cloudOrgs) {
          final idx = _db.organizations.indexWhere((o) => o.id == org.id);
          if (idx >= 0) {
            _db.organizations[idx] = org;
          } else {
            _db.organizations.add(org);
          }
        }
      }

      final empSnap = await _firestore!.collection('employees').get();
      if (empSnap.docs.isNotEmpty) {
        final cloudEmps = empSnap.docs.map((d) => Employee.fromMap(d.data())).toList();
        for (final emp in cloudEmps) {
          final idx = _db.employees.indexWhere((e) => e.id == emp.id);
          if (idx >= 0) {
            _db.employees[idx] = emp;
          } else {
            _db.employees.add(emp);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[EmployerProvider] Firestore sync note: $e');
    }
  }

  // Statistics & Real Analytics for Active Organization
  int get totalEmployees => employees.length;

  int get totalCoursesAssigned =>
      employees.fold(0, (acc, emp) => acc + emp.assignedCourseIds.length);

  int get totalCoursesCompleted =>
      employees.fold(0, (acc, emp) => acc + emp.completedCourseIds.length);

  double get teamAverageProgress {
    if (employees.isEmpty) return 0.0;
    final total = employees.fold(0.0, (acc, emp) => acc + emp.averageProgress);
    return total / employees.length;
  }

  // Department Distribution for Chart
  Map<String, int> get departmentDistribution {
    final Map<String, int> map = {};
    for (var emp in employees) {
      map[emp.department] = (map[emp.department] ?? 0) + 1;
    }
    return map;
  }

  // Organization CRUD
  void addOrganization(Organization org) {
    _db.organizations.add(org);
    notifyListeners();
    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('organizations').doc(org.id).set(org.toMap());
    } catch (e) {
      debugPrint('[EmployerProvider] Firestore add org note: $e');
    }
  }

  void updateOrganization(Organization org) {
    final idx = _db.organizations.indexWhere((o) => o.id == org.id);
    if (idx >= 0) {
      _db.organizations[idx] = org;
      notifyListeners();
      try {
        _firestore ??= FirebaseFirestore.instance;
        _firestore!.collection('organizations').doc(org.id).set(org.toMap());
      } catch (e) {
        debugPrint('[EmployerProvider] Firestore update org note: $e');
      }
    }
  }

  void deleteOrganization(String orgId) {
    _db.organizations.removeWhere((o) => o.id == orgId);
    notifyListeners();
    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('organizations').doc(orgId).delete();
    } catch (e) {
      debugPrint('[EmployerProvider] Firestore delete org note: $e');
    }
  }

  // Employee CRUD
  void addEmployee({
    required String name,
    required String email,
    required String department,
    List<String> initialCourseIds = const [],
  }) {
    final newEmp = Employee(
      id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
      orgId: organization.id,
      name: name.trim(),
      email: email.trim(),
      department: department.trim(),
      assignedCourseIds: initialCourseIds,
      averageProgress: 0.0,
    );

    _db.employees.add(newEmp);
    notifyListeners();

    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('employees').doc(newEmp.id).set(newEmp.toMap());
    } catch (e) {
      debugPrint('[EmployerProvider] Firestore add employee note: $e');
    }
  }

  void updateEmployee(Employee emp) {
    final idx = _db.employees.indexWhere((e) => e.id == emp.id);
    if (idx >= 0) {
      _db.employees[idx] = emp;
      notifyListeners();
      try {
        _firestore ??= FirebaseFirestore.instance;
        _firestore!.collection('employees').doc(emp.id).set(emp.toMap());
      } catch (e) {
        debugPrint('[EmployerProvider] Firestore update employee note: $e');
      }
    }
  }

  // Assign Course to Employee
  void assignCourseToEmployee(String employeeId, String courseId) {
    final index = _db.employees.indexWhere((e) => e.id == employeeId);
    if (index >= 0) {
      final emp = _db.employees[index];
      if (!emp.assignedCourseIds.contains(courseId)) {
        final updatedList = List<String>.from(emp.assignedCourseIds)..add(courseId);
        _db.employees[index] = emp.copyWith(assignedCourseIds: updatedList);
        notifyListeners();

        try {
          _firestore ??= FirebaseFirestore.instance;
          _firestore!.collection('employees').doc(employeeId).update({
            'assignedCourseIds': updatedList,
          });
        } catch (e) {
          debugPrint('[EmployerProvider] Firestore assign course note: $e');
        }
      }
    }
  }

  // Remove Employee
  void removeEmployee(String employeeId) {
    _db.employees.removeWhere((e) => e.id == employeeId);
    notifyListeners();

    try {
      _firestore ??= FirebaseFirestore.instance;
      _firestore!.collection('employees').doc(employeeId).delete();
    } catch (e) {
      debugPrint('[EmployerProvider] Firestore remove employee note: $e');
    }
  }
}
