import 'package:anestesia_web/firebase_options.dart';
import 'package:anestesia_web/src/app/app.dart';
import 'package:anestesia_web/src/infra/infra.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final moduleManager = await setup();

  setUrlStrategy(PathUrlStrategy());

  runApp(FormularioPacienteApp(moduleManager: moduleManager));
}

Future<ModuleManagerInterface> setup() async {
  final moduleManager = ModuleManager();
  await moduleManager.registerModules([AppModule()]);
  return moduleManager;
}
