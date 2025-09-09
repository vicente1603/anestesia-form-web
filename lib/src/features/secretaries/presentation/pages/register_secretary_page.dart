import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../../../common/common.dart';
import '../../../features.dart';

class RegisterSecretaryPage extends StatefulWidget {
  final SecretariesPresenter secretariesPresenter;
  const RegisterSecretaryPage({super.key, required this.secretariesPresenter});

  @override
  State<RegisterSecretaryPage> createState() => _RegisterSecretaryPageState();
}

class _RegisterSecretaryPageState extends State<RegisterSecretaryPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpfController = TextEditingController();

  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Secretária')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(
                Icons.assignment_ind,
                size: 64,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 24),

              Text(
                'Preencha os dados da secretária',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: 32),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: cpfController,
                inputFormatters: [cpfMaskFormatter],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: '000.000.000-00',
                  prefixIcon: Icon(Icons.assignment_ind_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final unmaskedCpf = cpfMaskFormatter.getUnmaskedText();
                  if (unmaskedCpf.isEmpty) {
                    return 'O campo CPF é obrigatório';
                  }
                  if (!CPFValidator.isValid(unmaskedCpf)) {
                    return 'CPF inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O email é obrigatório';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'A senha é obrigatória';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: widget.secretariesPresenter.state,
                  builder: (context, state, _) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          
                          await widget.secretariesPresenter.register(
                            fullName: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            cpf: cpfMaskFormatter.getUnmaskedText(),
                          );

                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          cpfController.clear();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Secretária cadastrada com sucesso!',
                              ),
                            ),
                          );

                           Navigator.of(context).pop(true);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          state is UILoadingState
                              ? const CircularProgressIndicator()
                              : const Text(
                                'Cadastrar',
                                style: TextStyle(fontSize: 16),
                              ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
