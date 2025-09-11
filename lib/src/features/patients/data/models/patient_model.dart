import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../features.dart';

class PatientModel extends PatientEntity {
  PatientModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.createdBySecretary,
    required super.formStatus,
    required super.token,
    required super.formSentAt,
    required super.createdAt,
    required super.doctorId,
    required super.cpf,
    required super.phone,
    required super.birthDate,
    required super.medicalInsurance,
  });

  Map<String, dynamic> toMap() => {
    'full_name': fullName,
    'email': email,
    'createdBySecretary': createdBySecretary,
    'formStatus': formStatus,
    'token': token,
    'formSentAt': FieldValue.serverTimestamp(),
    'createdAt': FieldValue.serverTimestamp(),
    'doctorId': doctorId,
    'cpf': cpf,
    'phone': phone,
    'birthDate': birthDate,
    'medicalInsurance': medicalInsurance,
    'form': form,
  };

  factory PatientModel.fromMap(String id, Map<String, dynamic> map) {
    return PatientModel(
      id: id,
      fullName: map['full_name'],
      email: map['email'],
      createdBySecretary: map['createdBySecretary'],
      formStatus: map['formStatus'],
      token: map['token'],
      formSentAt: map['formSentAt'],
      createdAt: map['createdAt'],
      doctorId: map['doctorId'],
      cpf: map['cpf'],
      phone: map['phone'],
      birthDate: map['birthDate'],
      medicalInsurance: map['medicalInsurance'],
    );
  }
}
