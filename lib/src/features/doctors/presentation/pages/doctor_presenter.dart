import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../features.dart';

class DoctorPresenter extends BasePresenter {
  final DoctorRepository doctorRepository;
  final SecretariesRepository secretariesRepository;
  final AuthRepository authRepository;

  DoctorPresenter({
    required this.doctorRepository,
    required this.secretariesRepository,
    required this.authRepository,
  });

  @override
  late ValueNotifier<UIState> state;

  late ValueNotifier<DoctorEntity?> doctor;

  String doctorId = '';

  String secretaryId = '';

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
    doctor = ValueNotifier(DoctorModel(fullName: '', email: '', uid: '', crm: ''));
  }

  Future<String> getsecretaryId() async {
    secretaryId = await authRepository.getCurrentUserId();
    return secretaryId;
  }

  Future<String> getDoctorIdBySecretary() async {
    doctorId = await secretariesRepository.getDoctorId(secretaryId);
    return doctorId;
  }

  Future<void> getDoctor() async {
    state.value = UILoadingState();

    try {
      doctor.value = await doctorRepository.getDoctor(doctorId);
      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }
}
