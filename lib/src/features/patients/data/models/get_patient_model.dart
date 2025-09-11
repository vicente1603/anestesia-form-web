import '../../../features.dart';

class GetPatientModel extends PatientEntity {
  GetPatientModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.doctorId,
    required super.cpf,
    required super.phone,
    required super.birthDate,
    required super.token,
    required super.medicalInsurance,
    required super.form,
    required super.formStatus,

  });

  factory GetPatientModel.fromMap(String id, Map<String, dynamic> map) {
    return GetPatientModel(
      id: id,
      fullName: map['full_name'],
      email: map['email'],
      doctorId: map['doctorId'],
      cpf: map['cpf'],
      phone: map['phone'],
      birthDate: map['birthDate'].toDate(),
      token: map['token'],
      medicalInsurance: map['medicalInsurance'],
      form: map['forms'] != null ? FormDataModel.fromMap(map['forms']): null,
      formStatus: map['formStatus'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': fullName,
      'full_name': email,
      'doctorId': doctorId,
      'cpf': cpf,
      'phone': phone,
      'birthDate': birthDate,
      'token': token,
      'medicalInsurance': medicalInsurance,
      'form': form,
      'formStatus': formStatus,
    };
  }
}
