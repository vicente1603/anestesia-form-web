import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../features.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseFirestore _firestore;

  AdminRepositoryImpl(this._firestore);

  @override
  Future<List<DoctorEntity>> getDoctors() async {
    final dio = Dio();

    final result = await dio.get('http://localhost:3000/v1/doctor');

    return (result.data as List).map((e) => DoctorModel.fromMap(e)).toList();
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
      }
    } catch (e) {
      debugPrint("ERRO INESPERADO: $e");
    }
  }

  @override
  Future<void> deleteDoctor(DoctorEntity doctor) async {
    try {
      final dio = Dio();

      await dio.delete('http://localhost:3000/v1/doctor/${doctor.uid}');
    } catch (e) {
      print(e);
    }
  }

    @override
  Future<void> disableDoctor(DoctorEntity doctor) async {
    try {
      final dio = Dio();

      await dio.put('http://localhost:3000/v1/doctor/disable/${doctor.uid}');
    } catch (e) {
      print(e);
    }
  }

    @override
  Future<void> enableDoctor(DoctorEntity doctor) async {
    try {
      final dio = Dio();

      await dio.put('http://localhost:3000/v1/doctor/enable/${doctor.uid}');
    } catch (e) {
      print(e);
    }
  }
}
