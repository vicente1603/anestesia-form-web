import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final FirebaseFirestore _firestore;

  DoctorRepositoryImpl(this._firestore);

  @override
  Future<DoctorEntity?> getDoctor(String doctorId) async {
    final query =
        await _firestore
            .collection('users')
            .where('uid', isEqualTo: doctorId)
            .limit(1)
            .get();

  if (query.docs.isNotEmpty) {
    final doc = query.docs.first;
    return DoctorModel.fromFirebaseMap(doc.data());
  }

  return null;        
  }
}
