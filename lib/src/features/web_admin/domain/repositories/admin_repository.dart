
import '../../../features.dart';

abstract class AdminRepository {
  Future<List<DoctorEntity>> getDoctors();
  Future<void> registerDoctor(DoctorEntity doctor, String password);
  Future<void> deleteDoctor(DoctorEntity doctor);
  Future<void> disableDoctor(DoctorEntity doctor);
  Future<void> enableDoctor(DoctorEntity doctor);

}
