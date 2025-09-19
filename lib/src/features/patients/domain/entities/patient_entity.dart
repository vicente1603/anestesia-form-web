import 'package:anestesia_web/src/features/features.dart';

class PatientEntity {
  final String id;
  final String fullName;
  final String email;
  final String cpf;
  final String phone;
  final DateTime birthDate;
  final String doctorId;
  final String? createdBySecretary;
  final DateTime? createdAt;
  final String medicalInsurance;
  final List<FormDataEntity> forms;

  const PatientEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.cpf,
    required this.phone,
    required this.doctorId,
    required this.birthDate,
    this.createdBySecretary,
    this.createdAt,
    required this.medicalInsurance,
    required this.forms,
  });
}
