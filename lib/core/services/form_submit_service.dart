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
    BuildContext context,
  ) async {
    try {
      final dio = Dio();
      final formData = FormData();

      final dynamicData = {
        "age": model.age,
        "weight": model.weight,
        "height": model.height,
        "surgery": model.surgery,
        "allergies": model.allergies,
        "diseases": model.diseases,
        "medications": model.medications,
        "drugs": model.drugs,
        "icu_history": model.icuHistory,
        "disabilities": model.disabilities,
        "previous_surgeries": model.previousSurgeries,
      };

      final String? patientId = await fetchPatientIdByToken(getTokenFromUrl()!);

      formData.fields.add(MapEntry('data', json.encode(dynamicData)));

      formData.fields.add(MapEntry('patientId', json.encode(patientId)));

      if (arquivoSelecionado != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(arquivoSelecionado!);
        await reader.onLoad.first;
        final bytes = reader.result as Uint8List;

        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: arquivoSelecionado!.name,
          contentType: MediaType('application', 'octet-stream'),
        );

        formData.files.add(MapEntry('fileUrl', multipartFile));
      }

      final response = await dio.post(
        'http://localhost:3000/v1/analysis',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FormSuccess();
      } else {
        return FormFailure('Erro ao enviar formulário. Tente novamente.');
      }
    } on DioException catch (e) {
      return FormFailure('Erro ao acessar a API');
    }
  }
}
