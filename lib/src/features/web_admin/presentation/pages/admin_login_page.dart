import 'package:flutter/material.dart';
import '../../../features.dart';

class AdminLoginPage extends StatefulWidget {
  final AdminPresenter presenter;

  const AdminLoginPage({super.key, required this.presenter});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final formKey = GlobalKey<FormState>();

  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  @override
  void initState() {
    widget.presenter.init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bem-vindo Admin!',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color.primary,
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
          
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await widget.presenter.login(
                        emailController.text,
                        passwordController.text,
                      );
          
                      final user = widget.presenter.user;
                      if (user != null && user.role == 'admin') {
                        Navigator.pushReplacementNamed(context, '/admin-home');
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Erro ao logar')));
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
                    child: const Text('Entrar', style: TextStyle(fontSize: 16)),
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
