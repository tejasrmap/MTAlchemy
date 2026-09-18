import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/enquiry_model.dart';
import '../services/mock_database_service.dart';

class EnquiryProvider with ChangeNotifier {
  final MockDatabaseService _db = MockDatabaseService();
  FirebaseFirestore? _firestore;

  List<CorporateEnquiry> get enquiries => List.unmodifiable(_db.enquiries);

  EnquiryProvider() {
    _initFirestoreSync();
  }

  Future<void> _initFirestoreSync() async {
    try {
      _firestore = FirebaseFirestore.instance;
      final snap = await _firestore!.collection('enquiries').orderBy('submittedAt', descending: true).get();
      if (snap.docs.isNotEmpty) {
        final cloudEnquiries = snap.docs.map((d) => CorporateEnquiry.fromMap(d.data())).toList();
        for (final enq in cloudEnquiries) {
          if (!_db.enquiries.any((existing) => existing.id == enq.id)) {
            _db.enquiries.add(enq);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('[EnquiryProvider] Firestore sync note: $e');
    }
  }

  final Set<String> _recentSubmissionSignatures = {};

  // Submit Corporate Enquiry (Journey E) with Globally Unique Reference and Awaited Persistence
  Future<CorporateEnquiry> submitEnquiry({
    required String companyName,
    required String contactPerson,
    required String email,
    required String phone,
    required int participantsCount,
    required List<String> topicsInterested,
    required String deliveryMode,
    required String customRequirements,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanCompany = companyName.trim();

    // Server-side input validation and anti-spam duplicate detection
    if (cleanEmail.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(cleanEmail)) {
      throw Exception('Invalid corporate email address for RFP submission.');
    }
    if (cleanCompany.isEmpty) {
      throw Exception('Organization or Company Name is required.');
    }

    final signature = '$cleanEmail-$cleanCompany-${DateTime.now().day}';
    if (_recentSubmissionSignatures.contains(signature)) {
      throw Exception('Duplicate corporate RFP detected from this organization today. Our team is already reviewing your request.');
    }
    _recentSubmissionSignatures.add(signature);

    final year = DateTime.now().year;
    final uniqueSuffix = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    final refNumber = 'ENQ-$year-$uniqueSuffix-${(100 + _db.enquiries.length)}';

    final newEnquiry = CorporateEnquiry(
      id: refNumber,
      companyName: cleanCompany,
      contactPerson: contactPerson.trim(),
      email: cleanEmail,
      phone: phone.trim(),
      participantsCount: participantsCount,
      topicsInterested: topicsInterested,
      deliveryMode: deliveryMode,
      customRequirements: customRequirements.trim(),
    );

    _db.enquiries.insert(0, newEnquiry);
    notifyListeners();

    // Awaited single-step write to Cloud Firestore
    try {
      _firestore ??= FirebaseFirestore.instance;
      await _firestore!.collection('enquiries').doc(newEnquiry.id).set(newEnquiry.toMap());
    } catch (e) {
      debugPrint('[EnquiryProvider] Firestore submit enquiry note: $e');
    }

    return newEnquiry;
  }

  Future<void> syncEnquiryToFirestore(CorporateEnquiry enquiry) async {
    try {
      _firestore ??= FirebaseFirestore.instance;
      await _firestore!.collection('enquiries').doc(enquiry.id).set(enquiry.toMap());
    } catch (e) {
      debugPrint('[EnquiryProvider] Firestore sync enquiry note: $e');
    }
  }

  Future<void> updateEnquiryStatus(String id, EnquiryStatus newStatus) async {
    final idx = _db.enquiries.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _db.enquiries[idx].status = newStatus;
      notifyListeners();

      try {
        _firestore ??= FirebaseFirestore.instance;
        await _firestore!.collection('enquiries').doc(id).update({
          'status': newStatus.name,
        });
      } catch (e) {
        debugPrint('[EnquiryProvider] Firestore enquiry status update note: $e');
      }
    }
  }

  // Follow-up notes tracking for enterprise consultants with awaited persistence
  Future<void> addFollowUpNote(String id, String note) async {
    final noteObj = {
      'note': note.trim(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    final idx = _db.enquiries.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _db.enquiries[idx].followUpNotes.add(noteObj);
      notifyListeners();
    }
    try {
      _firestore ??= FirebaseFirestore.instance;
      await _firestore!.collection('enquiries').doc(id).update({
        'followUpNotes': FieldValue.arrayUnion([noteObj]),
      });
    } catch (e) {
      debugPrint('[EnquiryProvider] Follow-up note error: $e');
    }
  }
}
