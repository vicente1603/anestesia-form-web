import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

class PatientModel extends PatientEntity {
  PatientModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.createdBySecretary,
    required super.createdAt,
    required super.doctorId,
    required super.cpf,
    required super.phone,
    required super.birthDate,
    required super.medicalInsurance,
    required super.forms,
  });

  Map<String, dynamic> toMap() => {
    'full_name': fullName,
    'email': email,
    'createdBySecretary': createdBySecretary,
    'formSentAt': FieldValue.serverTimestamp(),
    'createdAt': FieldValue.serverTimestamp(),
    'doctorId': doctorId,
    'cpf': cpf,
    'phone': phone,
    'birthDate': birthDate,
    'medicalInsurance': medicalInsurance,
    'form': forms,
  };

  factory PatientModel.fromMap(String id, Map<String, dynamic> map) {
    return PatientModel(
      id: id,
      fullName: map['full_name'],
      email: map['email'],
      createdBySecretary: map['createdBySecretary'],
      createdAt: map['createdAt'],
      doctorId: map['doctorId'],
      cpf: map['cpf'],
      phone: map['phone'],
      birthDate: map['birthDate'],
      medicalInsurance: map['medicalInsurance'],
      forms:
          map["forms"] != null
              ? (map["forms"] as List)
                  .map((e) => FormDataModel.fromMap(e))
                  .toList()
              : [],
    );
  }
}
