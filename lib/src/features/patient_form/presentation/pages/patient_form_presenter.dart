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

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
    formDataEntity = FormDataEntity();
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
