class PatientEntity {
  final String id;
  final String fullName;
  final String email;
  final String cpf;
  final String phone;
  final DateTime birthDate;
  final String doctorId;
  final String? createdBySecretary;
  final String? formStatus;
  final String? token;
  final DateTime? formSentAt;
  final DateTime? createdAt;

  const PatientEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.cpf,
    required this.phone,
    required this.doctorId,
    required this.birthDate,
    this.createdBySecretary,
    this.formStatus,
    this.token,
    this.formSentAt,
    this.createdAt,
  });
}
