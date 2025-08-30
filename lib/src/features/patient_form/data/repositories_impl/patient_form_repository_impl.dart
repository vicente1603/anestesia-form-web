import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import '../../../features.dart';
import 'dart:html' as html;

class PatientFormRepositoryImpl implements PatientFormRepository {
  PatientFormRepositoryImpl();

  String? getTokenFromUrl() {
    final uri =
        Uri.base; // Exemplo: https://anestesia-app.web.app/formulario?token=XYZ123
    return uri.queryParameters['token'];
  }

  Future<String?> fetchPatientIdByToken(String token) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .where('token', isEqualTo: token)
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
    final token = Uri.base.queryParameters['token'];

    if (token == null || token.isEmpty) {
      return false;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .where('token', isEqualTo: token)
            .where('formStatus', isEqualTo: 'pending')
            .limit(1)
            .get();

    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<InfoEntity?> getPatientInfo() async {
    final token = Uri.base.queryParameters['token'];

    if (token == null || token.isEmpty) {
      return null;
    }

    final String? patientId = await fetchPatientIdByToken(token);
    if (patientId == null) {
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

      final String? token = getTokenFromUrl();
      if (token == null) return FormFailure('Token não encontrado na URL.');

      final String? patientId = await fetchPatientIdByToken(token);
      if (patientId == null) {
        return FormFailure('Token inválido ou paciente não encontrado.');
      }

      formData.fields.add(MapEntry('patientId', patientId));

      final dynamicData = {
        "surgery": formDataEntity.surgery,
        "surgeon": formDataEntity.surgeon,
        "allergies": formDataEntity.allergies,
        "diseases": formDataEntity.diseases,
        "medications": formDataEntity.medications,
        "smokes": formDataEntity.smokes,
        "drugs": formDataEntity.drugs,
        "icu_history": formDataEntity.icuHistory,
        "disabilities": formDataEntity.disabilities,
        "previous_surgeries": formDataEntity.previousSurgeries,
        "postOpComplications": formDataEntity.postOpComplications,
        "previous_anesthesia": formDataEntity.familyAnesthesiaHistory,
        "age": "32",
        "weight": "110",
        "height": "1.54",
        "imc": "46.4",
        "gender": "Feminino",
      };

      dynamicData.forEach((key, value) {
        formData.fields.add(MapEntry('data[$key]', value!));
      });

      if (arquivoSelecionado != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(arquivoSelecionado);
        await reader.onLoad.first;
        final bytes = reader.result as Uint8List;

        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: arquivoSelecionado.name,
          contentType: MediaType.parse(arquivoSelecionado.type),
        );
        formData.files.add(MapEntry('fileUrl', multipartFile));
      }

      await dio.post('http://localhost:3000/v1/analysis', data: formData);

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
