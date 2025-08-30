import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../features.dart';
import 'dart:html' as html;

class PatientFormPresenter extends BasePresenter {
  final PatientFormRepository patientFormRepository;

  PatientFormPresenter({required this.patientFormRepository});

  @override
  late ValueNotifier<UIState> state;

  late FormDataEntity formDataEntity;

  late bool isTokenValid;

  late InfoEntity infoEntity;

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
    formDataEntity = FormDataEntity();
    isTokenValid = false;
    infoEntity = InfoEntity(birthDate: DateTime.now(), fullName: '');
  }

  Future<bool> validateToken() async {
    state.value = UILoadingState();

    try {
      final result = await patientFormRepository.validateToken();

      if (result) {
        state.value = UISuccessState('');
      } else {
        state.value = UIErrorState('erro');
      }

      isTokenValid = result;

      return isTokenValid;
    } catch (e) {
      state.value = UIErrorState(e.toString());
      return false;
    }
  }

  Future<void> getPatientInfo() async {
    state.value = UILoadingState();

    try {
      infoEntity = (await patientFormRepository.getPatientInfo())!;

      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<FormResult> submit(html.File? arquivoSelecionado) async {
    state.value = UILoadingState();

    final formData = formDataEntity;

    try {
      final result = await patientFormRepository.submitForm(
        formData,
        arquivoSelecionado,
      );

      if (result is FormSuccess) {
        state.value = UISuccessState('');
      } else if (result is FormFailure) {
        state.value = UIErrorState(result.message);
      }

      return result;
    } catch (e) {
      state.value = UIErrorState(e.toString());
      return FormFailure('Ocorreu um erro inesperado: $e');
    }
  }
}
