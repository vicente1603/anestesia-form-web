import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../infra/infra.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class FormularioPacienteApp extends StatelessWidget {
  final ModuleManagerInterface moduleManager;

  const FormularioPacienteApp({super.key, required this.moduleManager});

  @override
  Widget build(BuildContext context) {
    final providers = moduleManager.providers ?? [];

    final app = MaterialApp(
      title: 'Formulário Pré-Anestésico',
      navigatorKey: navigatorKey,
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      theme: appTheme,
      onGenerateRoute:
          (settings) => AppRouter.onGenerateRoute(settings, moduleManager),
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
