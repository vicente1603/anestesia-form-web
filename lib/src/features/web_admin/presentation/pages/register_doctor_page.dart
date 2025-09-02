import 'package:anestesia_web/src/common/common.dart';
import 'package:flutter/material.dart';
import '../../../features.dart';

class RegisterDoctorPage extends StatefulWidget {
  final AdminPresenter presenter;
  const RegisterDoctorPage({super.key, required this.presenter});

  @override
  State<RegisterDoctorPage> createState() => _RegisterDoctorPageState();
}

class _RegisterDoctorPageState extends State<RegisterDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _crmController = TextEditingController();
  final _passwordController = TextEditingController();

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
      backgroundColor: color.surfaceVariant.withOpacity(0.05),
      appBar: AppBar(
        title: const Text("Cadastrar Médico"),
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Formulário de Cadastro",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Preencha os dados do médico corretamente antes de cadastrar.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: color.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: "Nome completo",
                            validator:
                                (v) =>
                                    v == null || v.isEmpty
                                        ? "Informe o nome"
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            label: "E-mail",
                            validator:
                                (v) =>
                                    v == null || v.isEmpty
                                        ? "Informe o e-mail"
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _crmController,
                            label: "CRM",
                            validator:
                                (v) =>
                                    v == null || v.isEmpty
                                        ? "Informe o CRM"
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _passwordController,
                            label: "Senha",
                            obscureText: true,
                            validator:
                                (v) =>
                                    v == null || v.length < 6
                                        ? "Mínimo 6 caracteres"
                                        : null,
                          ),
                          const SizedBox(height: 32),
                          ValueListenableBuilder(
                            valueListenable: widget.presenter.state,
                            builder: (context, state, _) {
                              if (state is UILoadingState) {
                                return const CircularProgressIndicator();
                              }
                              return SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await widget.presenter.registerDoctor(
                                        fullName: _nameController.text,
                                        email: _emailController.text,
                                        crm: _crmController.text,
                                        password: _passwordController.text,
                                      );

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Médico cadastrado com sucesso!",
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color.primary,
                                    foregroundColor: color.onPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cadastrar",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      validator: validator,
    );
  }
}
