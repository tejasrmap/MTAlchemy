enum UserRole {
  guest,
  individual,
  employer,
  trainer,
  superAdmin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.guest:
        return 'Guest Visitor';
      case UserRole.individual:
        return 'Individual Learner';
      case UserRole.employer:
        return 'Corporate Employer';
      case UserRole.trainer:
        return 'Consultant / Trainer';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }

  String get badgeText {
    switch (this) {
      case UserRole.guest:
        return 'GUEST';
      case UserRole.individual:
        return 'LEARNER';
      case UserRole.employer:
        return 'EMPLOYER';
      case UserRole.trainer:
        return 'TRAINER';
      case UserRole.superAdmin:
        return 'ADMIN';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? gender;
  final String? country;
  final List<String> hobbies;
  final String? organizationId;
  final String? organizationName;
  final bool isEmailVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.gender,
    this.country,
    this.hobbies = const [],
    this.organizationId,
    this.organizationName,
    this.isEmailVerified = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'gender': gender,
      'country': country,
      'hobbies': hobbies,
      'organizationId': organizationId,
      'organizationName': organizationName,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() => toMap();

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.individual,
      ),
      gender: map['gender'],
      country: map['country'],
      hobbies: List<String>.from(map['hobbies'] ?? []),
      organizationId: map['organizationId'],
      organizationName: map['organizationName'],
      isEmailVerified: map['isEmailVerified'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? gender,
    String? country,
    List<String>? hobbies,
    String? organizationId,
    String? organizationName,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      hobbies: hobbies ?? this.hobbies,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
