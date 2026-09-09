class Employee {
  final String id;
  final String orgId;
  final String name;
  final String email;
  final String department;
  final List<String> assignedCourseIds;
  final List<String> completedCourseIds;
  final double averageProgress; // e.g., 0.65 for 65%

  Employee({
    required this.id,
    required this.orgId,
    required this.name,
    required this.email,
    required this.department,
    this.assignedCourseIds = const [],
    this.completedCourseIds = const [],
    this.averageProgress = 0.0,
  });

  Employee copyWith({
    String? id,
    String? orgId,
    String? name,
    String? email,
    String? department,
    List<String>? assignedCourseIds,
    List<String>? completedCourseIds,
    double? averageProgress,
  }) {
    return Employee(
      id: id ?? this.id,
      orgId: orgId ?? this.orgId,
      name: name ?? this.name,
      email: email ?? this.email,
      department: department ?? this.department,
      assignedCourseIds: assignedCourseIds ?? this.assignedCourseIds,
      completedCourseIds: completedCourseIds ?? this.completedCourseIds,
      averageProgress: averageProgress ?? this.averageProgress,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'orgId': orgId,
        'name': name,
        'email': email,
        'department': department,
        'assignedCourseIds': assignedCourseIds,
        'completedCourseIds': completedCourseIds,
        'averageProgress': averageProgress,
      };

  factory Employee.fromMap(Map<String, dynamic> map) => Employee(
        id: map['id'],
        orgId: map['orgId'],
        name: map['name'],
        email: map['email'],
        department: map['department'] ?? 'General',
        assignedCourseIds: List<String>.from(map['assignedCourseIds'] ?? []),
        completedCourseIds: List<String>.from(map['completedCourseIds'] ?? []),
        averageProgress: (map['averageProgress'] as num?)?.toDouble() ?? 0.0,
      );
}

class Organization {
  final String id;
  final String name;
  final String industry;
  final String contactEmail;
  final String contactPhone;
  final int totalSeatsPurchased;
  final DateTime joinedDate;

  Organization({
    required this.id,
    required this.name,
    required this.industry,
    required this.contactEmail,
    required this.contactPhone,
    this.totalSeatsPurchased = 25,
    DateTime? joinedDate,
  }) : joinedDate = joinedDate ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'industry': industry,
        'contactEmail': contactEmail,
        'contactPhone': contactPhone,
        'totalSeatsPurchased': totalSeatsPurchased,
        'joinedDate': joinedDate.toIso8601String(),
      };

  factory Organization.fromMap(Map<String, dynamic> map) => Organization(
        id: map['id'],
        name: map['name'],
        industry: map['industry'] ?? 'Corporate',
        contactEmail: map['contactEmail'] ?? '',
        contactPhone: map['contactPhone'] ?? '',
        totalSeatsPurchased: map['totalSeatsPurchased'] ?? 25,
        joinedDate: DateTime.parse(map['joinedDate']),
      );
}

