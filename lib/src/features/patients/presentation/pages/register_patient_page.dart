import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../../features.dart';

class RegisterPatientPage extends StatefulWidget {
  final PatientsPresenter patientsPresenter;

  const RegisterPatientPage({super.key, required this.patientsPresenter});

  @override
  State<RegisterPatientPage> createState() => _RegisterPacientPageState();
}

class _RegisterPacientPageState extends State<RegisterPatientPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final birthDateController = TextEditingController();
  final phoneController = TextEditingController();
  final medicalInsuranceController = TextEditingController();

  final cpfMaskFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    widget.patientsPresenter.init();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cpfController.dispose();
    birthDateController.dispose();
    phoneController.dispose();
    medicalInsuranceController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formattedDate =
          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
      birthDateController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Paciente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Informações do Paciente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome completo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cpfController,
                inputFormatters: [cpfMaskFormatter],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: '000.000.000-00',
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
              const SizedBox(height: 12),
              TextFormField(
                controller: medicalInsuranceController,
                decoration: const InputDecoration(
                  labelText: 'Convênio Médico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O convênio é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: birthDateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento',
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
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
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                inputFormatters: [phoneMaskFormatter],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  hintText: '(00) 00000-0000',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    DateTime? birthDate;

                    try {
                      birthDate = DateFormat(
                        'dd/MM/yyyy',
                      ).parse(birthDateController.text);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Formato de data inválido. Use DD/MM/AAAA',
                          ),
                        ),
                      );
                      return;
                    }

                    await widget.patientsPresenter.register(
                      fullName: nameController.text,
                      email: emailController.text,
                      cpf: cpfMaskFormatter.getUnmaskedText(),
                      birthDate: birthDate,
                      phone: phoneController.text,
                      medicalInsurance: medicalInsuranceController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Paciente cadastrado com sucesso!'),
                      ),
                    );
                    nameController.clear();
                    emailController.clear();
                    cpfController.clear();
                    birthDateController.clear();
                    phoneController.clear();
                    medicalInsuranceController.clear();

                    Navigator.of(context).pop(true);
                  }
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Cadastrar Paciente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
