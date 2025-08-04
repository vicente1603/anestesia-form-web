import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class FormularioPacienteApp extends StatelessWidget {
  const FormularioPacienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FormularioPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _cirurgiaController = TextEditingController();
  final _alergiasController = TextEditingController();
  final _doencasController = TextEditingController();
  final _medicamentosController = TextEditingController();
  final _drogasController = TextEditingController();
  final _utiController = TextEditingController();
  final _perdasController = TextEditingController();
  final _cirurgiasAnterioresController = TextEditingController();

  html.File? _arquivoSelecionado;

  void _selecionarArquivo() {
    final uploadInput =
        html.FileUploadInputElement()..accept = 'image/*,application/pdf';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      if (file != null) {
        setState(() => _arquivoSelecionado = file);
      }
    });
  }

  Future<void> _enviarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final dio = Dio();
      final formData = FormData();

      final dynamicData = {
        "age": _ageController.text,
        "weight": _weightController.text,
        "height": _heightController.text,
        "surgery": _cirurgiaController.text,
        "allergies": _alergiasController.text,
        "diseases": _doencasController.text,
        "medications": _medicamentosController.text,
        "drugs": _drogasController.text,
        "icu_history": _utiController.text,
        "disabilities": _perdasController.text,
        "previous_surgeries": _cirurgiasAnterioresController.text,
      };

      formData.fields.add(MapEntry('data', json.encode(dynamicData)));

      if (_arquivoSelecionado != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(_arquivoSelecionado!);
        await reader.onLoad.first;
        final bytes = reader.result as Uint8List;

        final multipartFile = MultipartFile.fromBytes(
          bytes,
          filename: _arquivoSelecionado!.name,
          contentType: MediaType('application', 'octet-stream'),
        );

        formData.files.add(MapEntry('fileUrl', multipartFile));
      }

      final response = await dio.post(
        'http://localhost:3000/v1/analysis',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados enviados com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao enviar dados.')));
      }
    } on DioException catch (e) {
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      print('Response headers: ${e.response?.headers}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.response?.data ?? e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário de Anestesia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Idade'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Peso'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(labelText: 'Altura'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _cirurgiaController,
                decoration: const InputDecoration(
                  labelText:
                      'Qual cirurgia vai realizar? Quem é o seu cirurgião?',
                ),
                validator:
                    (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                controller: _alergiasController,
                decoration: const InputDecoration(
                  labelText: 'Tem alguma alergia a medicamentos ou alimentos?',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _doencasController,
                decoration: const InputDecoration(
                  labelText: 'Tem alguma doença?',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _medicamentosController,
                decoration: const InputDecoration(
                  labelText: 'Medicamentos em uso habitual/repetido',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _drogasController,
                decoration: const InputDecoration(
                  labelText: 'Fuma? Usa alguma droga?',
                ),
              ),
              TextFormField(
                controller: _utiController,
                decoration: const InputDecoration(
                  labelText: 'Já esteve internado em UTI?',
                ),
              ),
              TextFormField(
                controller: _perdasController,
                decoration: const InputDecoration(
                  labelText: 'Tem alguma perda de visão, audição ou movimento?',
                ),
                maxLines: 2,
              ),
              TextFormField(
                controller: _cirurgiasAnterioresController,
                decoration: const InputDecoration(
                  labelText: 'Quais cirurgias já fez?',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _selecionarArquivo,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  _arquivoSelecionado == null
                      ? 'Selecionar arquivo'
                      : 'Arquivo selecionado: ${_arquivoSelecionado!.name}',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enviarFormulario,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
