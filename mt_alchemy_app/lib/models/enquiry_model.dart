enum EnquiryStatus {
  submitted,
  underReview,
  proposalSent,
  scheduled,
}

class CorporateEnquiry {
  final String id;
  final String companyName;
  final String contactPerson;
  final String email;
  final String phone;
  final int participantsCount;
  final List<String> topicsInterested;
  final String deliveryMode; // In-Person, Virtual, Hybrid
  final String customRequirements;
  final DateTime submittedAt;
  final List<Map<String, dynamic>> followUpNotes;
  EnquiryStatus status;

  CorporateEnquiry({
    required this.id,
    required this.companyName,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.participantsCount,
    required this.topicsInterested,
    this.deliveryMode = 'Hybrid',
    required this.customRequirements,
    this.followUpNotes = const [],
    DateTime? submittedAt,
    this.status = EnquiryStatus.submitted,
  }) : submittedAt = submittedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'companyName': companyName,
        'contactPerson': contactPerson,
        'email': email,
        'phone': phone,
        'participantsCount': participantsCount,
        'topicsInterested': topicsInterested,
        'deliveryMode': deliveryMode,
        'customRequirements': customRequirements,
        'followUpNotes': followUpNotes,
        'submittedAt': submittedAt.toIso8601String(),
        'status': status.name,
      };

  factory CorporateEnquiry.fromMap(Map<String, dynamic> map) =>
      CorporateEnquiry(
        id: map['id'],
        companyName: map['companyName'] ?? '',
        contactPerson: map['contactPerson'] ?? '',
        email: map['email'] ?? '',
        phone: map['phone'] ?? '',
        participantsCount: map['participantsCount'] ?? 10,
        topicsInterested: List<String>.from(map['topicsInterested'] ?? []),
        deliveryMode: map['deliveryMode'] ?? 'Hybrid',
        customRequirements: map['customRequirements'] ?? '',
        followUpNotes: List<Map<String, dynamic>>.from(
          (map['followUpNotes'] as List?)?.map((n) => Map<String, dynamic>.from(n)) ?? [],
        ),
        submittedAt: DateTime.parse(map['submittedAt']),
        status: EnquiryStatus.values.firstWhere(
          (s) => s.name == map['status'],
          orElse: () => EnquiryStatus.submitted,
        ),
      );
}

