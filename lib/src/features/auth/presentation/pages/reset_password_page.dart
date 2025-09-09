import 'package:flutter/material.dart';
import '../../../../common/common.dart';
import '../../../features.dart';

class ResetPasswordPage extends StatefulWidget {
  final LoginPresenter presenter;

  const ResetPasswordPage({super.key, required this.presenter});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  static final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.presenter.init();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    await widget.presenter.resetPassword(emailController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('E-mail de redefinição enviado!')),
    );
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_reset_rounded, size: 80, color: color.primary),

                const SizedBox(height: 24),

                Text(
                  'Redefinir senha',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Digite seu e-mail para receber o link de redefinição.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: color.onBackground.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 32),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder(
                    valueListenable: widget.presenter.state,
                    builder: (context, state, _) {
                      return ElevatedButton(
                        onPressed:
                            state is UILoadingState ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.primary,
                          foregroundColor: color.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            state is UILoadingState
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Enviar',
                                  style: TextStyle(fontSize: 16),
                                ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed:
                      () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text(
                    'Voltar para login',
                    style: TextStyle(color: color.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
