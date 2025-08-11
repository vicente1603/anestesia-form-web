import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../features.dart';

class PatientFormPage extends StatefulWidget {
  const PatientFormPage({super.key});

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final formKey = GlobalKey<FormState>();
  final model = FormDataModel();
  html.File? arquivoSelecionado;
  bool isLoading = true;
  bool isTokenValid = false;

  @override
  void initState() {
    super.initState();
    _validateToken();
  }

  Future<void> _validateToken() async {
    final token = Uri.base.queryParameters['token'];

    final snapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .where('token', isEqualTo: token)
            .where('formStatus', isEqualTo: 'pending')
            .limit(1)
            .get();

    if (token == null || token.isEmpty) {
      setState(() {
        isLoading = false;
        isTokenValid = false;
      });
      return;
    }

    setState(() {
      isTokenValid = snapshot.docs.isNotEmpty;
      isLoading = false;
    });
  }

  void _selectFile() {
    final uploadInput =
        html.FileUploadInputElement()..accept = 'image/*,application/pdf';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      if (file != null) {
        setState(() => arquivoSelecionado = file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!isTokenValid) {
      return Scaffold(
        body: Center(
          child: Text(
            "Token inválido ou expirado.",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: color.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: color.background,
      appBar: AppBar(
        title: const Text("Formulário Pré-Anestésico"),
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.assignment_rounded, size: 72, color: color.primary),
              const SizedBox(height: 16),
              Text(
                'Formulário Pré-Anestésico',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha com suas informações antes da consulta.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    FormFields(model: model),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _selectFile,
                        icon: const Icon(Icons.upload_file),
                        label: Text(
                          arquivoSelecionado == null
                              ? 'Selecionar arquivo'
                              : 'Arquivo: ${arquivoSelecionado!.name}',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color.primary,
                          foregroundColor: color.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            final result = await FormSubmitService.submitForm(
                              model,
                              arquivoSelecionado,
                              context,
                            );

                            if (result is FormSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Formulário enviado!"),
                                ),
                              );
                            } else if (result is FormFailure) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.message)),
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
                        child: const Text(
                          'Enviar',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
