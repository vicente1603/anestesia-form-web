import '../../../features.dart';

abstract class SecretariesRepository {
  Future<List<SecretaryEntity>> getSecretariesByDoctor(String doctorId);
  Future<String> getDoctorId(String secretaryId);
  Future<void> registerSecretary(SecretaryEntity secretary, String password);
  Future<void> deleteSecretary(SecretaryEntity secretary);
}
