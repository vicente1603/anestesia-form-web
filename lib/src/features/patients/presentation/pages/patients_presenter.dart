import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../common/common.dart';
import '../../../features.dart';
import 'dart:html' as html;

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
    required String medicalInsurance,
  }) async {
    state.value = UILoadingState();

    final uid = await authRepository.getCurrentUserId();
    String doctorId = '';

    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

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
        medicalInsurance: medicalInsurance,
      );

      await patientsRepository.registerPatient(patient);

      this.doctorId = doctorId;
      await getPatients();

      state.value = UISuccessState('');
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }

  Future<void> sendLink(BuildContext context, String token) async {
    final link = 'https://anestesia-app-bdf0d.web.app?token=$token';

    try {
      await Clipboard.setData(ClipboardData(text: link));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Link copiado para a área de transferência'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Não foi possível copiar. Abra manualmente: $link'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
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
