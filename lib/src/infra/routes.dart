part of 'module/module_interface.dart';

abstract class Routes {
  static Map<String, WidgetBuilder> routes(Injector i) => {
    '/patient-form': (context) => PatientFormPage(presenter: i.get(), token: '',),
    '/admin-login': (context) => AdminLoginPage(presenter: i.get()),
    '/admin-home': (context) => AdminHomePage(presenter: i.get()),
    '/register-doctor':
        (context) => RegisterDoctorPage(presenter: i.get()),
  };
}
