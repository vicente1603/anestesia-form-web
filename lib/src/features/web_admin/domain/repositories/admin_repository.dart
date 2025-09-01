
import '../../../features.dart';

abstract class AdminRepository {
  Future<FirebaseUser> signInWithEmail(String email, String password);
  
  Future<void> signOut();

  Future<void> getDoctors();

  Future<void> registerDoctor();

  Future<void> deleteDoctor();
}
