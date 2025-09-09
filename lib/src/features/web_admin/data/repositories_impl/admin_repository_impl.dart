import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../features.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AdminRepositoryImpl(this._firebaseAuth, this._firestore);

  // @override
  // Future<FirebaseUser> signInWithEmail(String email, String password) async {
  //   final credential = await _firebaseAuth.signInWithEmailAndPassword(
  //     email: email,
  //     password: password,
  //   );

  //   final uid = credential.user!.uid;
  //   final userEmail = credential.user!.email ?? '';
  //   final userName = credential.user!.displayName ?? '';

  //   final userRef = _firestore.collection('users').doc(uid);
  //   final doc = await userRef.get();

  //   if (!doc.exists) {
  //     await userRef.set({
  //       'uid': uid,
  //       'email': userEmail,
  //       'name': userName,
  //       'role': 'admin',
  //       'createdAt': FieldValue.serverTimestamp(),
  //       'blocked': false,
  //     });
  //   }

  //   final updatedDoc = await userRef.get();
  //   return FirebaseUser.fromMap(updatedDoc.data()!);
  // }

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
    try {
      final userMap = {
        'name': doctor.fullName,
        'email': doctor.email,
        'crm': doctor.crm,
        'password': password,
      };

      final data = {"data": userMap};

      final dio = Dio();

      dio.post('http://localhost:3000/v1/doctor', data: data);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("ERRO DO SERVIDOR: ${e.response?.data}");
        final message =
            e.response?.data?['message'] ?? 'Ocorreu um erro desconhecido.';
      }
    } catch (e) {
      debugPrint("ERRO INESPERADO: $e");
    }
  }

  @override
  Future<void> deleteDoctor(DoctorEntity doctor) async {
    final docRef = _firestore.collection('users').doc(doctor.uid);

    await docRef.delete();
  }
}
