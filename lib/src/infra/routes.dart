part of 'module/module_interface.dart';

abstract class Routes {
  static Map<String, WidgetBuilder> routes(Injector i) => {
    '/patient-form':
        (context) => PatientFormPage(presenter: i.get(), token: ''),
    '/admin-login': (context) => AdminLoginPage(presenter: i.get()),
    '/admin-home':
        (context) =>
            AdminHomePage(adminPresenter: i.get(), loginPresenter: i.get()),
    '/register-doctor': (context) => RegisterDoctorPage(presenter: i.get()),
    '/login': (context) => LoginPage(presenter: i.get()),
    '/reset-password': (context) => ResetPasswordPage(presenter: i.get()),
    '/home-doctor':
        (context) => DoctorPage(
          doctorPresenter: i.get(),
          secretariesPresenter: i.get(),
          patientsPresenter: i.get(),
          loginPresenter: i.get(),
        ),
    '/home-secretary':
        (context) => SecretaryPage(
          secretariesPresenter: i.get(),
          doctorPresenter: i.get(),
          patientsPresenter: i.get(),
          loginPresenter: i.get(),
        ),
    '/register-secretary':
        (context) => RegisterSecretaryPage(secretariesPresenter: i.get()),
    '/register-patient':
        (context) => RegisterPatientPage(patientsPresenter: i.get()),
    '/patient-detail': (context) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (arguments == null) {
        return const NotFoundPage();
      }

      return PatientDetailPage(
        patient: arguments['patient'] as GetPatientModel,
        patientsPresenter: i.get(),
        patientFormPresenter: i.get(),
      );
    },
    '/secretary-detail': (context) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

      return SecretaryDetailPage(
        secretary: arguments['secretary'] as GetSecretaryModel,
        presenter: i.get(),
      );
    },
  };
}
