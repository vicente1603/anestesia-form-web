import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../features.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AdminRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final userEmail = credential.user!.email ?? '';
    final userName = credential.user!.displayName ?? '';

    final userRef = _firestore.collection('users').doc(uid);
    final doc = await userRef.get();

    if (!doc.exists) {
      await userRef.set({
        'uid': uid,
        'email': userEmail,
        'name': userName,
        'role': 'admin',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    final updatedDoc = await userRef.get();
    return FirebaseUser.fromMap(updatedDoc.data()!);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> getDoctors() async {}

  @override
  Future<void> registerDoctor() async {}

  @override
  Future<void> deleteDoctor() async {}
}
