
import '../../../features.dart';

abstract class AdminRepository {
  // Future<FirebaseUser> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<List<DoctorEntity>> getDoctors();
  Future<void> registerDoctor(DoctorEntity doctor, String password);
  Future<void> deleteDoctor(DoctorEntity doctor);
}
