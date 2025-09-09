import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../features.dart';

class SecretariesPresenter extends BasePresenter {
  final SecretariesRepository secretariesRepository;
  final AuthRepository authRepository;

  SecretariesPresenter({
    required this.secretariesRepository,
    required this.authRepository,
  });

  @override
  late ValueNotifier<UIState> state;

  late ValueNotifier<List<SecretaryEntity>> secretaries;

  String doctorId = '';

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
    secretaries = ValueNotifier([]);
  }

  Future<String> getDoctorId() async {
    doctorId = await authRepository.getCurrentUserId();
    return doctorId;
  }

  Future<void> getSecretaries() async {
    state.value = UILoadingState();

    try {
      secretaries.value = await secretariesRepository.getSecretariesByDoctor(
        doctorId,
      );

      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String cpf,
  }) async {
    state.value = UILoadingState();

    final uid = await authRepository.getCurrentUserId();

    try {
      final secretary = SecretaryEntity(
        uid: '',
        fullName: fullName,
        email: email,
        cpf: cpf,
        associatedDoctorId: uid,
        createdAt: null,
      );
      await secretariesRepository.registerSecretary(secretary, password);
      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<void> deleteSecretary(SecretaryEntity secretary) async {
    secretariesRepository.deleteSecretary(secretary);
  }
}
