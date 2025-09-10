import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.crm,
    super.createdAt,
  });

  static DateTime? mapToDateTime(Map<String, dynamic>? map) {
    if (map == null) return null;
    final seconds = map['_seconds'] as int?;
    final nanoseconds = map['_nanoseconds'] as int? ?? 0;
    if (seconds == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + nanoseconds ~/ 1000000,
    );
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      uid: map['id'] ?? '',
      fullName: map['name'] ?? '',
      email: map['email'] ?? '',
      crm: map['crm'] ?? '',
      createdAt: mapToDateTime(map['createdAt'] as Map<String, dynamic>?),
    );
  }

  factory DoctorModel.fromFirebaseMap(Map<String, dynamic> map) {
    return DoctorModel(
      uid: map['uid'] ?? '',
      fullName: map['name'] ?? '',
      email: map['email'] ?? '',
      crm: map['crm'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': fullName,
      'email': email,
      'crm': crm,
      'role': 'doctor',
      'createdAt': createdAt,
    };
  }
}
