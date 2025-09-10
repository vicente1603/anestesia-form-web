import 'dart:html' as html;
import 'dart:io';
import 'package:anestesia_web/src/common/ui_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../features.dart';
import 'package:intl/intl.dart';

class PatientFormPage extends StatefulWidget {
  final PatientFormPresenter presenter;
  final String token;

  const PatientFormPage({
    super.key,
    required this.presenter,
    required this.token,
  });

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class _PatientFormPageState extends State<PatientFormPage> {
  final formKey = GlobalKey<FormState>();
  final model = FormDataModel();
  String patientName = '';
  String patientBirthDate = '';

  html.File? arquivoSelecionado;

  @override
  void initState() {
    super.initState();
    widget.presenter.init();
    widget.presenter.validateToken();
    getPatientInfo();
  }

  Future<void> getPatientInfo() async {
    await widget.presenter.getPatientInfo();

    setState(() {
      patientName = widget.presenter.infoEntity.fullName ?? '';
      patientBirthDate = DateFormat(
        'dd/MM/yyyy',
      ).format(widget.presenter.infoEntity.birthDate!);
    });
  }

  Future<void> _pickFileOrImage() async {
    // showModalBottomSheet(
    //   context: context,
    //   builder:
    //       (ctx) => SafeArea(
    //         child: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             ListTile(
    //               leading: const Icon(Icons.upload_file),
    //               title: const Text('Selecionar arquivo'),
    //               onTap: () async {
    //                 Navigator.pop(ctx);
    //                 final result = await FilePicker.platform.pickFiles(
    //                   type: FileType.any,
    //                 );
    //                 if (result != null && result.files.isNotEmpty) {
    //                   final path = result.files.first.path;
    //                   if (path != null) {
    //                     setState(() {
    //                       arquivoSelecionado = File(path);
    //                     });
    //                   }
    //                 }
    //               },
    //             ),
    //             ListTile(
    //               leading: const Icon(Icons.camera_alt),
    //               title: const Text('Tirar foto'),
    //               onTap: () async {
    //                 Navigator.pop(ctx);
    //                 final image = await ImagePicker().pickImage(
    //                   source: ImageSource.camera,
    //                 );
    //                 if (image != null) {
    //                   setState(() {
    //                     arquivoSelecionado = File(image.path);
    //                   });
    //                 }
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return ValueListenableBuilder(
      valueListenable: widget.presenter.state,
      builder: (context, state, _) {
        if (state is UILoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (!widget.presenter.isTokenValid) {
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
        } else {
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
                                'Nome: $patientName',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: color.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Data de Nascimento: $patientBirthDate ',
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
                                    FormFields(presenter: widget.presenter),
                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: _pickFileOrImage,
                                        icon: const Icon(Icons.upload_file),
                                        label: Text(
                                          arquivoSelecionado == null
                                              ? 'Selecionar arquivo ou tirar foto'
                                              : 'Arquivo: ${arquivoSelecionado!}',
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            final result = await widget
                                                .presenter
                                                .submit(arquivoSelecionado);

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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                Container(
                  color: color.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
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
      },
    );
  }
}
