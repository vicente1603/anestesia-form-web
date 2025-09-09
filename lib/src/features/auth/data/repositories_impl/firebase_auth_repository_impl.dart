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

      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.server));

      if (!doc.exists) {
        await _firebaseAuth.signOut();
        throw UserNotFoundException();
      }

      final data = doc.data()!;
      final blocked = data['blocked'] as bool? ?? false;
      if (blocked) {
        await _firebaseAuth.signOut();
        throw BlockedUserException();
      }

      return FirebaseUser.fromMap(data);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') throw WrongPasswordException();
      if (e.code == 'user-not-found') throw UserNotFoundException();
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
  Future<bool?> getBlocked(String uid) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.server));

      if (!doc.exists) return null;

      final data = doc.data();
      return data?['blocked'] as bool?;
    } catch (e) {
      final cached = await _firestore
          .collection('users')
          .doc(uid)
          .get(const GetOptions(source: Source.cache));
      if (!cached.exists) return null;
      return cached.data()?['blocked'] as bool?;
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
  Future<void> blockedUser(String uid) async {
    final userRef = _firestore.collection('users').doc(uid);
    await userRef.update({'blocked': true});
  }
}
