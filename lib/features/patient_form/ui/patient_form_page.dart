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

    if (token == null || token.isEmpty) {
      setState(() {
        isLoading = false;
        isTokenValid = false;
      });
      return;
    }

    final snapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .where('token', isEqualTo: token)
            .where('formStatus', isEqualTo: 'pending')
            .limit(1)
            .get();

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
            style: theme.textTheme.titleLarge?.copyWith(
              color: color.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: color.surfaceVariant.withOpacity(0.1),
      appBar: AppBar(
        title: const Text("Formulário Pré-Anestésico"),
        backgroundColor: color.primary,
        foregroundColor: color.onPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 40,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_rounded,
                            size: 64,
                            color: color.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Formulário Pré-Anestésico',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: color.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Preencha cuidadosamente suas informações antes da consulta. '
                            'Os dados serão analisados pela equipe médica para garantir a sua segurança.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: color.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 32),

                          Text(
                            'Nome:  ',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Data de Nascimento:  ',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                FormFields(model: model),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _selectFile,
                                    icon: const Icon(Icons.upload_file),
                                    label: Text(
                                      arquivoSelecionado == null
                                          ? 'Selecionar arquivo (exames, laudos...)'
                                          : 'Arquivo: ${arquivoSelecionado!.name}',
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
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
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        final result =
                                            await FormSubmitService.submitForm(
                                              model,
                                              arquivoSelecionado,
                                            );

                                        if (result is FormSuccess) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Formulário enviado com sucesso!",
                                              ),
                                            ),
                                          );
                                        } else if (result is FormFailure) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(result.message),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: color.primary,
                                      foregroundColor: color.onPrimary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Enviar Formulário',
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
                ),
              ),
            ),
          ),
          Container(
            color: color.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Text(
                'Os dados informados neste formulário serão utilizados exclusivamente '
                'para fins médicos e de segurança anestésica, sendo protegidos conforme '
                'a LGPD (Lei Geral de Proteção de Dados). Nenhuma informação será compartilhada '
                'com terceiros sem o seu consentimento.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
