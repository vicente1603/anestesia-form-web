import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../common/common.dart';
import '../../../features.dart';

class LoginPresenter extends BasePresenter {
  final AuthRepository authRepository;

  LoginPresenter({required this.authRepository});

  FirebaseUser? user;

  @override
  late ValueNotifier<UIState> state;

  @override
  Future<void> init() async {
    state = ValueNotifier(UIInitialState());
  }

  Future<void> login(String email, String password) async {
    state.value = UILoadingState();

    try {
      user = await authRepository.signInWithEmail(email, password);
      state.value = UISuccessState('');
    } on BlockedUserException catch (e) {
      user = null;
      state.value = UIErrorState(e.message);
    } on UserNotFoundException catch (e) {
      user = null;
      state.value = UIErrorState(e.message);
    } on WrongPasswordException catch (e) {
      user = null;
      state.value = UIErrorState(e.message);
    } catch (e) {
      user = null;
      state.value = UIErrorState('Erro inesperado: $e');
    }
  }

  Future<String> getCurrentUserId() async {
    state.value = UILoadingState();

    try {
      String userId = await authRepository.getCurrentUserId();
      state.value = UISuccessState('');
      return userId;
    } catch (e) {
      state.value = UIErrorState(e.toString());
      return '';
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }

  Future<String?> getRole(String uid) async {
    try {
      return await authRepository.getUserRole(uid);
    } catch (e) {
      state.value = UIErrorState(e.toString());
      return '';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await authRepository.resetPassword(email);
    } catch (e) {
      state.value = UIErrorState(e.toString());
    }
  }
}
