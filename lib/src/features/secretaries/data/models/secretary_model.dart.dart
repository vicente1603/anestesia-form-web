import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/secretary_entity.dart';

class SecretaryModel extends SecretaryEntity {
  SecretaryModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.associatedDoctorId,
    required super.createdAt,
    required super.cpf,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'associatedDoctorId': associatedDoctorId,
      'createdAt': FieldValue.serverTimestamp(),
      'cpf': cpf,
    };
  }

  factory SecretaryModel.fromMap(Map<String, dynamic> map) {
    return SecretaryModel(
      uid: map['uid'],
      fullName: map['fullName'],
      email: map['email'],
      associatedDoctorId: map['associatedDoctorId'],
      createdAt: map['createdAt'],
      cpf: map['cpf'],
    );
  }
}
