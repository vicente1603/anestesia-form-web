
import '../../data/models/firebase_user_model.dart';

abstract class AuthRepository {
  Future<FirebaseUser> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<String> getCurrentUserId();
  Future<String?> getUserRole(String uid);
  Future<void> resetPassword(String email);
  Future<void> blockedUser(String uid);
  Future<bool?> getBlocked(String uid);

}
