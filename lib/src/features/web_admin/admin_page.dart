import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String role = 'doctor';
  List<String> associatedDoctors = [];

  Future<void> _createUser() async {
    final dio = Dio();

    final response = await dio.post(
      'http://localhost:3000/v1/users', // ajuste aqui
      options: Options(contentType: 'application/json'),
      data: jsonEncode({
        'email': email,
        'password': password,
        'name': name,
        'role': role,
        'associated_doctors': associatedDoctors,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário criado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ao criar usuário')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administração de Usuários')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome completo'),
                onChanged: (value) => name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                onChanged: (value) => password = value,
              ),
              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: 'doctor', child: Text('Médico')),
                  DropdownMenuItem(
                    value: 'secretary',
                    child: Text('Secretária'),
                  ),
                ],
                onChanged: (value) => setState(() => role = value!),
              ),
              if (role == 'secretary') ...[
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText:
                        'IDs dos médicos associados (separados por vírgula)',
                  ),
                  onChanged:
                      (value) =>
                          associatedDoctors =
                              value.split(',').map((e) => e.trim()).toList(),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createUser,
                child: const Text('Criar Usuário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
