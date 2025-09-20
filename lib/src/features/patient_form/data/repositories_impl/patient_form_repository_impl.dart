import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../features.dart';
import 'dart:html' as html;

class PatientFormRepositoryImpl implements PatientFormRepository {
  PatientFormRepositoryImpl();

  String? getPatientIdFromUrl() {
    final uri = Uri.base;
    return uri.queryParameters['patientId'];
  }

  Future<String?> fetchPatientIdById(String patientId) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .where('uid', isEqualTo: patientId)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  @override
  Future<bool> validateToken() async {
    try {
      final patientId = Uri.base.queryParameters['patientId'];
      final token = Uri.base.queryParameters['token'];

      if (patientId == null ||
          patientId.isEmpty ||
          token == null ||
          token.isEmpty) {
        return false;
      }

      final doc =
          await FirebaseFirestore.instance
              .collection('patients')
              .doc(patientId)
              .get();

      if (!doc.exists) return false;

      final data = doc.data();
      if (data == null || !data.containsKey('forms')) return false;

      final forms =
          (data['forms'] as List<dynamic>)
              .map((e) => Map<String, dynamic>.from(e as Map))
              .toList();

      final hasValidForm = forms.any(
        (form) => form['token'] == token && form['formStatus'] == 'pending',
      );

      return hasValidForm;
    } catch (e, st) {
      print('validateToken error: $e');
      print(st);
      return false;
    }
  }

  @override
  Future<InfoEntity?> getPatientInfo() async {
    final patientId = Uri.base.queryParameters['patientId'];

    if (patientId == null || patientId.isEmpty) {
      return null;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .get();

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }
    final data = snapshot.data() as Map<String, dynamic>;

    return InfoModel.fromMap(data);
  }

  @override
  Future<FormResult> submitForm(
    FormDataEntity formDataEntity,
    html.File? arquivoSelecionado,
  ) async {
    try {
      final dio = Dio();
      final formData = FormData();

      final String? patientId = getPatientIdFromUrl();
      if (patientId == null) {
        return FormFailure('Token inválido ou paciente não encontrado.');
      }

      final dynamicData = {
        "surgery": formDataEntity.surgery,
        "surgeon": formDataEntity.surgeon,
        "hospital": formDataEntity.hospital,
        "gender": formDataEntity.gender,
        "weight": formDataEntity.weight,
        "height": formDataEntity.height,
        "hasAllergies": formDataEntity.hasAllergies,
        "allergiesDetail": formDataEntity.allergiesDetail,
        "hasDiseases": formDataEntity.hasDiseases,
        "diseasesDetail": formDataEntity.diseasesDetail,
        "usesMedication": formDataEntity.usesMedication,
        "medicationsDetail": formDataEntity.medicationsDetail,
        "smokes": formDataEntity.smokes,
        "usesDrugs": formDataEntity.usesDrugs,
        "drugsDetail": formDataEntity.drugsDetail,
        "icuHistory": formDataEntity.icuHistory,
        "icuHistoryDetail": formDataEntity.icuHistoryDetail,
        "disabilities": formDataEntity.disabilities,
        "disabilitiesDetail": formDataEntity.disabilitiesDetail,
        "hasPreviousSurgeries": formDataEntity.hasPreviousSurgeries,
        "previousSurgeriesDetail": formDataEntity.previousSurgeriesDetail,
        "postOpComplications": formDataEntity.postOpComplications,
        "familyAnesthesiaHistory": formDataEntity.familyAnesthesiaHistory,
        "formId": formDataEntity.formId,
        "formStatus": formDataEntity.formStatus,
        "token": formDataEntity.token,
        "createAt": formDataEntity.createAt,
        "updatedAt": formDataEntity.updatedAt,
      };

      dynamicData.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry('data[$key]', value.toString()));
        }
      });

      await dio.put(
        'http://localhost:3000/v1/form/send/patient/$patientId/token/${formDataEntity.token}',
        data: formData,
      );

      return FormSuccess();
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("ERRO DO SERVIDOR: ${e.response?.data}");
        final message =
            e.response?.data?['message'] ?? 'Ocorreu um erro desconhecido.';
        return FormFailure('Falha na API: $message');
      }
      return FormFailure('Erro de conexão: ${e.message}');
    } catch (e) {
      debugPrint("ERRO INESPERADO: $e");
      return FormFailure('Ocorreu um erro inesperado: $e');
    }
  }

  @override
  Future<FormResult> updateForm(FormDataEntity formDataEntity) async {
    try {
      final dio = Dio();
      final formData = FormData();

      final String? patientId = getPatientIdFromUrl();
      if (patientId == null) {
        return FormFailure('Token inválido ou paciente não encontrado.');
      }

      final dynamicData = {
        "surgery": formDataEntity.surgery,
        "surgeon": formDataEntity.surgeon,
        "hospital": formDataEntity.hospital,
        "gender": formDataEntity.gender,
        "weight": formDataEntity.weight,
        "height": formDataEntity.height,
        "hasAllergies": formDataEntity.hasAllergies,
        "allergiesDetail": formDataEntity.allergiesDetail,
        "hasDiseases": formDataEntity.hasDiseases,
        "diseasesDetail": formDataEntity.diseasesDetail,
        "usesMedication": formDataEntity.usesMedication,
        "medicationsDetail": formDataEntity.medicationsDetail,
        "smokes": formDataEntity.smokes,
        "usesDrugs": formDataEntity.usesDrugs,
        "drugsDetail": formDataEntity.drugsDetail,
        "icuHistory": formDataEntity.icuHistory,
        "icuHistoryDetail": formDataEntity.icuHistoryDetail,
        "disabilities": formDataEntity.disabilities,
        "disabilitiesDetail": formDataEntity.disabilitiesDetail,
        "hasPreviousSurgeries": formDataEntity.hasPreviousSurgeries,
        "previousSurgeriesDetail": formDataEntity.previousSurgeriesDetail,
        "postOpComplications": formDataEntity.postOpComplications,
        "familyAnesthesiaHistory": formDataEntity.familyAnesthesiaHistory,
      };

      dynamicData.forEach((key, value) {
        if (value != null) {
          formData.fields.add(MapEntry('data[$key]', value.toString()));
        }
      });

      await dio.put(
        'http://localhost:3000/v1/form/send/patient/$patientId/token/${formDataEntity.token}',
        data: formData,
      );

      return FormSuccess();
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("ERRO DO SERVIDOR: ${e.response?.data}");
        final message =
            e.response?.data?['message'] ?? 'Ocorreu um erro desconhecido.';
        return FormFailure('Falha na API: $message');
      }
      return FormFailure('Erro de conexão: ${e.message}');
    } catch (e) {
      debugPrint("ERRO INESPERADO: $e");
      return FormFailure('Ocorreu um erro inesperado: $e');
    }
  }
}
