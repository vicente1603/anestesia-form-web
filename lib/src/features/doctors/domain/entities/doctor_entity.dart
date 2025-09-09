class DoctorEntity {
  final String uid;
  final String fullName;
  final String email;
  final String crm;
  final DateTime? createdAt;
  final bool? blocked;

  DoctorEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.crm,
    this.createdAt,
    this.blocked,
  });
}
