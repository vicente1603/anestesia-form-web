import '../../../features.dart';

class GetPatientModel extends PatientEntity {
  GetPatientModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.doctorId,
    required super.cpf,
    required super.phone,
    required super.birthDate,
    required super.medicalInsurance,
    required super.forms,
  });

  factory GetPatientModel.fromMap(Map<String, dynamic> map) {
    return GetPatientModel(
      uid: map['uid'],
      fullName: map['full_name'],
      email: map['email'],
      doctorId: map['doctorId'],
      cpf: map['cpf'],
      phone: map['phone'],
      birthDate: map['birthDate'].toDate(),
      medicalInsurance: map['medicalInsurance'],
      forms:
          map["forms"] != null
              ? (map["forms"] as List)
                  .map((e) => FormDataModel.fromMap(e))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': fullName,
      'full_name': email,
      'doctorId': doctorId,
      'cpf': cpf,
      'phone': phone,
      'birthDate': birthDate,
      'medicalInsurance': medicalInsurance,
      'forms': forms,
    };
  }
}
