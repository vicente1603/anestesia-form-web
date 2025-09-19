import '../../../features.dart';

abstract class PatientsRepository {
  Future<void> registerPatient(PatientEntity patient);
  Future<List<PatientEntity>> getPatientsByDoctor(String doctorId);
  Future<void> deletePatient(PatientEntity patient);
  Future<String> generateFormLink(String id);
}
