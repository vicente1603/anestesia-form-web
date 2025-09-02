part of 'module/module_interface.dart';

abstract class Routes {
  static const patientForm = '/patient-form';
  static const adminLogin = '/admin-login';
  static const adminHome = '/admin-home';
  static const registerDoctor = '/register-doctor';

  static Map<String, WidgetBuilder> routes(Injector i) => {
    patientForm: (context) => PatientFormPage(presenter: i.get(), token: ''),
    adminLogin: (context) => AdminLoginPage(presenter: i.get()),
    adminHome: (context) => AdminHomePage(presenter: i.get()),
    registerDoctor: (context) => RegisterDoctorPage(presenter: i.get()),
  };
}
