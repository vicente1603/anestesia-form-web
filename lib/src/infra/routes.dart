part of 'module/module_interface.dart';

abstract class Routes {
  static Map<String, WidgetBuilder> routes(Injector i) => {
    '/patient-form': (context) => PatientFormPage(presenter: i.get()),
    '/login-admin': (context) => LoginAdminPage(presenter: i.get()),
    '/home-admin': (context) => HomeAdminPage(presenter: i.get()),
  };
}
