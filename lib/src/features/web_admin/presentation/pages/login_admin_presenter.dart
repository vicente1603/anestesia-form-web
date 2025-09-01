import 'dart:async';
import 'package:anestesia_web/src/common/common.dart';
import 'package:flutter/material.dart';

import '../../../features.dart';

class LoginAdminPresenter extends BasePresenter {
  final AdminRepository adminmRepository;

  LoginAdminPresenter({required this.adminmRepository});

  @override
  late ValueNotifier<UIState> state;

  FirebaseUser? user;

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
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
}
