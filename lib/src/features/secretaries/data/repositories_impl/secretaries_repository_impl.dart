import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../../features.dart';

class SecretariesRepositoryImpl implements SecretariesRepository {
  final FirebaseFirestore _firestore;

  SecretariesRepositoryImpl(this._firestore);

  @override
  Future<List<SecretaryEntity>> getSecretariesByDoctor(String doctorId) async {
    final query =
        await _firestore
            .collection('users')
            .where('role', isEqualTo: 'secretary')
            .where('associatedDoctorId', isEqualTo: doctorId)
            .get();

    return query.docs
        .map((doc) => GetSecretaryModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<String> getDoctorId(String secretaryId) async {
    final doc = await _firestore.collection('users').doc(secretaryId).get();
    final data = doc.data();
    if (data != null && data['role'] == 'secretary') {
      return data['associatedDoctorId'] ?? '';
    }
    return '';
  }

  @override
  Future<void> registerSecretary(
    SecretaryEntity secretary,
    String password,
  ) async {
    final secondaryApp = await Firebase.initializeApp(
      name: 'SecondaryApp',
      options: Firebase.app().options,
    );

    try {
      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      final userCredential = await secondaryAuth.createUserWithEmailAndPassword(
        email: secretary.email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final userMap = {
        'uid': uid,
        'name': secretary.fullName,
        'email': secretary.email,
        'role': 'secretary',
        'associatedDoctorId': secretary.associatedDoctorId,
        'cpf': secretary.cpf,
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
  Future<void> deleteSecretary(SecretaryEntity secretary) async {
    final docRef = _firestore.collection('users').doc(secretary.uid);

    await docRef.delete();
    // _authRepository.blockedUser(secretary.uid);
  }
}
