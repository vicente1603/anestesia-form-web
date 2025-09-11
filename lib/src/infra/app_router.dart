import 'package:anestesia_web/src/infra/not_found_page.dart';
import 'package:flutter/material.dart';
import '../features/features.dart';
import '../infra/infra.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
    ModuleManagerInterface moduleManager,
  ) {
    final uri = Uri.parse(settings.name ?? '');

    if (uri.path == '/patient-form') {
      final token = uri.queryParameters['token'] ?? '';
      final builder = moduleManager.routes?['/patient-form'];

      if (builder != null) {
        final basePage =
            builder.call(navigatorKey.currentContext!) as PatientFormPage;

        return MaterialPageRoute(
          builder:
              (_) =>
                  PatientFormPage(presenter: basePage.presenter, token: token),
          settings: settings,
        );
      }
    }

    final builder = moduleManager.routes?[uri.path];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    return MaterialPageRoute(
      builder: (_) => const NotFoundPage(),
      settings: settings,
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
