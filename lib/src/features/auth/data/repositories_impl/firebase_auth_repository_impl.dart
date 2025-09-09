import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../features.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository(this._firebaseAuth, this._firestore);

  @override
  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      final userRef = _firestore.collection('users').doc(uid);
      final doc = await userRef.get(const GetOptions(source: Source.server));

      if (!doc.exists) {
        await userRef.set({
          'uid': uid,
          'email': email,
          'name': password,
          'role': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
          'blocked': false,
        });
      }

      final data = doc.data()!;

      return FirebaseUser.fromMap(data);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') throw WrongPasswordException();
      if (e.code == 'user-not-found') throw UserNotFoundException();
      if (e.code == 'user-disabled') throw UserDisabledException();

      rethrow;
    } catch (e) {
      if (_firebaseAuth.currentUser != null) {
        await _firebaseAuth.signOut();
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<String> getCurrentUserId() async {
    final user = _firebaseAuth.currentUser;
    return user!.uid;
  }

  @override
  Future<String?> getUserRole(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) return null;

      final data = doc.data();
      final role = data?['role'] as String?;

      return role;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  @override
  Future<void> blockUser(String uid) async {}
}
