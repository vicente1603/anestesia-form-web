import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../../../infra/infra.dart';
import '../../../doctors/doctors.dart';
import '../../../secretaries/presentation/presentation.dart';
import '../../auth.dart';

class AuthGate extends StatelessWidget {
  final LoginPresenter loginPresenter;
  const AuthGate({super.key, required this.loginPresenter});

  Future<_AuthResult> _checkUserData(User user) async {
    final blocked = await loginPresenter.getBlocked(user.uid);
    if (blocked == true) return _AuthResult(blocked: true);

    final role = await loginPresenter.getRole(user.uid);
    return _AuthResult(role: role);
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final user = snapshot.data;
        if (user == null) {
          return LoginPage(presenter: GetIt.I<LoginPresenter>());
        }

        return FutureBuilder<_AuthResult>(
          future: _checkUserData(user),
          builder: (context, resultSnapshot) {
            if (resultSnapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }

            if (resultSnapshot.hasError) {
              return _ErrorScreen(error: resultSnapshot.error.toString());
            }

            final result = resultSnapshot.data;
            if (result == null) {
              return const _ErrorScreen(error: 'Erro desconhecido');
            }

            if (result.blocked) {
              auth.signOut();
              return LoginPage(
                presenter: DM.get(),
                errorMessage: 'Usuário não existe',
              );
            }

            switch (result.role) {
              case 'doctor':
                return DoctorPage(
                  doctorPresenter: DM.get(),
                  loginPresenter: DM.get(),
                  patientsPresenter: DM.get(),
                  secretariesPresenter: DM.get(),
                );
              case 'secretary':
                return SecretaryPage(
                  doctorPresenter: DM.get(),
                  loginPresenter: DM.get(),
                  patientsPresenter: DM.get(),
                  secretariesPresenter: DM.get(),
                );
              default:
                return _MessageScreen(
                  message: 'Usuário sem função definida',
                  action: () => auth.signOut(),
                );
            }
          },
        );
      },
    );
  }
}

class _AuthResult {
  final bool blocked;
  final String? role;
  _AuthResult({this.blocked = false, this.role});
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _ErrorScreen extends StatelessWidget {
  final String error;
  const _ErrorScreen({required this.error});
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Erro: $error')));
}

class _MessageScreen extends StatelessWidget {
  final String message;
  final VoidCallback? action;
  const _MessageScreen({required this.message, this.action});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          if (action != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: action, child: const Text('Sair')),
          ],
        ],
      ),
    ),
  );
}
