class Certificate {
  final String id;
  final String certificateNumber;
  final String courseId;
  final String courseTitle;
  final String userId;
  final String userName;
  final DateTime issueDate;
  final String grade;
  final String issuer;

  bool get isDistinction => grade.toLowerCase().contains('distinction');

  Certificate({
    required this.id,
    required this.certificateNumber,
    required this.courseId,
    required this.courseTitle,
    required this.userId,
    required this.userName,
    DateTime? issueDate,
    this.grade = 'Distinction (95%)',
    this.issuer = 'MT Alchemy People Development Consultancy',
  }) : issueDate = issueDate ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'certificateNumber': certificateNumber,
        'courseId': courseId,
        'courseTitle': courseTitle,
        'userId': userId,
        'userName': userName,
        'issueDate': issueDate.toIso8601String(),
        'grade': grade,
        'issuer': issuer,
      };

  factory Certificate.fromMap(Map<String, dynamic> map) => Certificate(
        id: map['id'],
        certificateNumber: map['certificateNumber'],
        courseId: map['courseId'],
        courseTitle: map['courseTitle'],
        userId: map['userId'],
        userName: map['userName'],
        issueDate: DateTime.parse(map['issueDate']),
        grade: map['grade'] ?? 'Pass',
        issuer: map['issuer'] ?? 'MT Alchemy',
      );
}

