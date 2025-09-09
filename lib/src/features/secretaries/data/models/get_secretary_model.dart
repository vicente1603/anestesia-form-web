import '../../../features.dart';

class GetSecretaryModel extends SecretaryEntity {
  GetSecretaryModel({
    required super.uid,
    required super.fullName,
    required super.cpf,
    required super.email,
    required super.associatedDoctorId,
    required super.createdAt,
  });

  factory GetSecretaryModel.fromMap(String id, Map<String, dynamic> map) {
    return GetSecretaryModel(
      uid: id,
      fullName: map['name'],
      cpf: map['cpf'],
      email: map['email'],
      associatedDoctorId: map['associatedDoctorId'],
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'cpf': cpf,
      'email': email,
      'associatedDoctorId': associatedDoctorId,
      'createdAt': createdAt,
    };
  }
}
