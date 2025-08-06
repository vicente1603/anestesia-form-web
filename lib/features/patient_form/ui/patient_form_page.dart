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

  Future<bool> isValidToken(String token) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .where('token', isEqualTo: token)
            .limit(1)
            .get();

    return snapshot.docs.isNotEmpty;
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

  void selecionarArquivo() {
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
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!isTokenValid) {
      return const Scaffold(
        body: Center(child: Text("Token inválido ou expirado.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Formulário Pré-Anestésico")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              FormFields(model: model),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: selecionarArquivo,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  arquivoSelecionado == null
                      ? 'Selecionar arquivo'
                      : 'Arquivo selecionado: ${arquivoSelecionado!.name}',
                ),
              ),
              const SizedBox(height: 20),
              SubmitButton(
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    await FormSubmitService.submitForm(
                      model,
                      arquivoSelecionado,
                      context,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Formulário enviado!")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
