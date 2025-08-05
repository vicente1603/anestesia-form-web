import 'package:anestesia_web/firebase_options.dart';
import 'package:anestesia_web/features/patient_form/ui/patient_form_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FormularioPacienteApp());
}

class FormularioPacienteApp extends StatelessWidget {
  const FormularioPacienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário Pré-Anestésico',
      home: PatientFormPage(),
    );
  }
}
