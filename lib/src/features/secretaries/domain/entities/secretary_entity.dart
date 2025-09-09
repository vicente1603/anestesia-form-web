class SecretaryEntity {
  final String uid;
  final String fullName;
  final String email;
  final String cpf;
  final String associatedDoctorId;
  final DateTime? createdAt;

  const SecretaryEntity({
    required this.uid,
    required this.fullName,
    required this.cpf,
    required this.email,
    required this.associatedDoctorId,
    this.createdAt,
  });
}
