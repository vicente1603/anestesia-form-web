import 'dart:async';
import 'package:anestesia_web/src/common/common.dart';
import 'package:flutter/material.dart';

import '../../../features.dart';

class AdminPresenter extends BasePresenter {
  final AdminRepository adminmRepository;

  AdminPresenter({required this.adminmRepository});

  @override
  late ValueNotifier<UIState> state;

  FirebaseUser? user;

  late ValueNotifier<List<DoctorEntity>> doctors;

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
    doctors = ValueNotifier([]);
  }

  Future<void> login(String email, String password) async {
    state.value = UILoadingState();

    try {
      user = await adminmRepository.signInWithEmail(email, password);
      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<void> signOut() async {
    await adminmRepository.signOut();
  }

  Future<void> registerDoctor({
    required String fullName,
    required String email,
    required String crm,
    required String password,
  }) async {
    state.value = UILoadingState();

    try {
      final doctor = DoctorEntity(
        uid: '',
        fullName: fullName,
        email: email,
        crm: crm,
      );

      await adminmRepository.registerDoctor(doctor, password);

      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<void> deleteDoctor(DoctorEntity doctor) async {
    await adminmRepository.deleteDoctor(doctor);
  }

  Future<void> getDoctors() async {
    state.value = UILoadingState();

    try {
      doctors.value = await adminmRepository.getDoctors();

      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }
}
