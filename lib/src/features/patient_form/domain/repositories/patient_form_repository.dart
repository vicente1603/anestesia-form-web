import '../../../features.dart';
import 'dart:html' as html;

abstract class PatientFormRepository {
  Future<FormResult> submitForm(
    FormDataEntity formData,
    html.File? arquivoSelecionado,
  );
}
