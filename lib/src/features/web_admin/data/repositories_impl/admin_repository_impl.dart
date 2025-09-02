import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
  Future<List<DoctorEntity>> getDoctors() async {
    final query =
        await _firestore
            .collection('users')
            .where('role', isEqualTo: 'doctor')
            .get();

    return query.docs
        .map((doc) => DoctorModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> registerDoctor(DoctorEntity doctor, String password) async {
    final secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: Firebase.app().options,
    );

    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      final userCredential = await secondaryAuth.createUserWithEmailAndPassword(
        email: doctor.email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final userMap = {
        'uid': uid,
        'name': doctor.fullName,
        'email': doctor.email,
        'role': 'doctor',
        'crm': doctor.crm,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('users').doc(uid).set(userMap);

      await secondaryAuth.signOut();
      await secondaryApp.delete();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteDoctor(DoctorEntity doctor) async {
    final docRef = _firestore.collection('users').doc(doctor.uid);

    await docRef.delete();
  }
}
