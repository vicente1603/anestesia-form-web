import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/common.dart';
import '../../../features.dart';

class PatientsPresenter extends BasePresenter {
  final PatientsRepository doctorRepository;
  final SecretariesRepository secretariesRepository;
  final PatientsRepository patientsRepository;
  final AuthRepository authRepository;

  PatientsPresenter({
    required this.doctorRepository,
    required this.secretariesRepository,
    required this.patientsRepository,
    required this.authRepository,
  });

  @override
  late ValueNotifier<UIState> state;

  late ValueNotifier<List<PatientEntity>> patients;

  String doctorId = '';

  String secretaryId = '';

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
    patients = ValueNotifier([]);
  }

  Future<String> getSecretaryId() async {
    secretaryId = await authRepository.getCurrentUserId();
    return secretaryId;
  }

  Future<String> getDoctorId() async {
    doctorId = await authRepository.getCurrentUserId();
    return doctorId;
  }

  Future<String> getDoctorIdBySecretary() async {
    doctorId = await secretariesRepository.getDoctorId(secretaryId);
    return doctorId;
  }

  Future<void> getPatients() async {
    state.value = UILoadingState();

    try {
      patients.value = await doctorRepository.getPatientsByDoctor(doctorId);
      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String cpf,
    required DateTime birthDate,
    required String phone,
  }) async {
    state.value = UILoadingState();

    final uid = await authRepository.getCurrentUserId();
    String doctorId = '';

    final docSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

    if (docSnapshot.exists) {
      doctorId = docSnapshot.data()?['associatedDoctorId'];
      print('Doctor ID: $doctorId');
    } else {
      print('Documento da secretária não existe.');
    }

    try {
      final patient = PatientEntity(
        id: '',
        fullName: fullName,
        email: email,
        createdBySecretary: uid,
        token: generateToken(),
        doctorId: doctorId,
        cpf: cpf,
        birthDate: birthDate,
        phone: phone,
      );

      await patientsRepository.registerPatient(patient);

      this.doctorId = doctorId;
      await getPatients();

      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<void> sendLink(String token) async {
    SharePlus.instance.share(
      ShareParams(text: 'https://anestesia-app-bdf0d.web.app?token=$token'),
    );
  }

  Future<void> deletePatient(PatientEntity patient) async {
    patientsRepository.deletePatient(patient);
  }

  String generateToken({int length = 6}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    return List.generate(
      length,
      (_) => chars[rand.nextInt(chars.length)],
    ).join();
  }
}
