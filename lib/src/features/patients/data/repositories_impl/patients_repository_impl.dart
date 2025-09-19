import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../features.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final FirebaseFirestore _firestore;

  PatientsRepositoryImpl(this._firestore);

  @override
  Future<List<PatientEntity>> getPatientsByDoctor(String doctorId) async {
    final query =
        await _firestore
            .collection('patients')
            .where('doctorId', isEqualTo: doctorId)
            .get();

    return query.docs
        .map((doc) => GetPatientModel.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> registerPatient(PatientEntity patient) async {
    final docRef = _firestore.collection('patients').doc();

    final patientModel = PatientModel(
      id: docRef.id,
      fullName: patient.fullName,
      email: patient.email,
      createdBySecretary: patient.createdBySecretary,
      createdAt: null,
      doctorId: patient.doctorId,
      cpf: patient.cpf,
      phone: patient.phone,
      birthDate: patient.birthDate,
      medicalInsurance: patient.medicalInsurance,
      forms: [],
    );

    await docRef.set(patientModel.toMap());
  }

  @override
  Future<String> generateFormLink(String id) async {
    try {
      final dio = Dio();

      final dynamicData = {"token": generateToken(), "formStatus": "pending"};

      final result = await dio.post(
        'http://localhost:3000/v1/form/generate/patient/$id',
        data: dynamicData,
      );

      return result.data;
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("ERRO DO SERVIDOR: ${e.response?.data}");
        final message =
            e.response?.data?['message'] ?? 'Ocorreu um erro desconhecido.';
        return 'Falha na API: $message';
      }
      return 'Erro de conexão: ${e.message}';
    } catch (e) {
      debugPrint("ERRO INESPERADO: $e");
      return 'Ocorreu um erro inesperado: $e';
    }
  }

  @override
  Future<void> deletePatient(PatientEntity patient) async {
    final docRef = _firestore.collection('patients').doc(patient.id);

    await docRef.delete();
  }

  String generateToken({int length = 6}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }
}
