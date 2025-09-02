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

  factory DoctorModel.fromMap(String id, Map<String, dynamic> map) {
    return DoctorModel(
      uid: id,
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
