import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final FirebaseFirestore _firestore;

  PatientsRepositoryImpl(this._firestore);

  @override
  Future<List<PatientEntity>> getPatientsByDoctor(String doctorId) async {
    final query =
        await _firestore
            .collection('patients')
            .where('doctorId', isEqualTo: doctorId)
            .get();

    return query.docs
        .map((doc) => GetPatientModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> registerPatient(PatientEntity patient) async {
    final docRef = _firestore.collection('patients').doc();

    final patientModel = PatientModel(
      id: docRef.id,
      fullName: patient.fullName,
      email: patient.email,
      createdBySecretary: patient.createdBySecretary,
      formStatus: "pending",
      token: patient.token,
      formSentAt: null,
      createdAt: null,
      doctorId: patient.doctorId,
      cpf: patient.cpf,
      phone: patient.phone,
      birthDate: patient.birthDate,
    );

    await docRef.set(patientModel.toMap());
  }

  @override
  Future<void> deletePatient(PatientEntity patient) async {
    final docRef = _firestore.collection('patients').doc(patient.id);

    await docRef.delete();
  }
}
