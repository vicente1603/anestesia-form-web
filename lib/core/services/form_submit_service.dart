import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:anestesia_web/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import '../../features/patient_form/models/form_data_model.dart';

class FormSubmitService {
  static String? getTokenFromUrl() {
    final uri =
        Uri.base; // Exemplo: https://anestesia-app.web.app/formulario?token=XYZ123
    return uri.queryParameters['token'];
  }

  static Future<String?> fetchPatientIdByToken(String token) async {
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

  static Future<FormResult> submitForm(
    FormDataModel model,
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
        "surgery": model.surgery,
        "surgeon": model.surgeon,
        "allergies": model.allergies,
        "diseases": model.diseases,
        "medications": model.medications,
        "smokes": model.smokes,
        "drugs": model.drugs,
        "icuHistory": model.icuHistory,
        "disabilities": model.disabilities,
        "previousSurgeries": model.previousSurgeries,
        "postOpComplications": model.postOpComplications,
        "familyAnesthesiaHistory": model.familyAnesthesiaHistory,
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
