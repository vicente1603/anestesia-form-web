import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/features.dart';
import '../infra/infra.dart';

class FormularioPacienteApp extends StatelessWidget {
  final ModuleManagerInterface moduleManager;

  const FormularioPacienteApp({super.key, required this.moduleManager});

  @override
  Widget build(BuildContext context) {
    final providers = moduleManager.providers ?? [];

    final app = MaterialApp(
      title: 'Formulário Pré-Anestésico',
      home: PatientFormPage(presenter: DM.get()),
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routes: moduleManager.routes ?? {},
    );

    if (providers.isNotEmpty) {
      return MultiProvider(providers: providers, child: app);
    }
    return app;
  }
}

final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF4DA1FF)),
  useMaterial3: true,
  fontFamily: 'Roboto',
);
