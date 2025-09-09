import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import '../../../features.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;
  final String? errorMessage;

  const LoginPage({super.key, required this.presenter, this.errorMessage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  @override
  void initState() {
    widget.presenter.init();

    if (widget.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(widget.errorMessage!)));
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_hospital_rounded,
                size: 80,
                color: color.primary,
              ),

              const SizedBox(height: 24),

              Text(
                'Bem-vindo!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Faça login para continuar',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color.onBackground.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 32),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ValueListenableBuilder<UIState>(
                valueListenable: widget.presenter.state,
                builder: (context, state, _) {
                  if (state is UIErrorState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.description)),
                      );
                    });
                  }
                  return const SizedBox.shrink();
                },
              ),

              ValueListenableBuilder<UIState>(
                valueListenable: widget.presenter.state,
                builder: (context, state, _) {
                  final isLoading = state is UILoadingState;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () async {
                                await widget.presenter.login(
                                  emailController.text,
                                  passwordController.text,
                                );

                                final user = widget.presenter.user;
                                if (user != null) {
                                  if (user.role == 'doctor') {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home-doctor',
                                    );
                                  } else if (user.role == 'secretary') {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home-secretary',
                                    );
                                  }
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Entrar',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/reset-password');
                },
                child: Text(
                  'Esqueci minha senha',
                  style: TextStyle(color: color.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
