part of 'module/module_interface.dart';

abstract class AppBinds {
  static void binds(Injector i) {
    _repositories(i);
    _presenters(i);
  }

  static void _repositories(Injector i) {
    i.registerFactory<PatientFormRepository>(PatientFormRepositoryImpl());

    i.registerFactory<AdminRepository>(
      AdminRepositoryImpl(FirebaseAuth.instance, FirebaseFirestore.instance),
    );
  }

  static void _presenters(Injector i) {
    i.registerFactory<PatientFormPresenter>(
      PatientFormPresenter(patientFormRepository: i.get()),
    );

    i.registerFactory<AdminPresenter>(
      AdminPresenter(adminmRepository: i.get()),
    );
  }
}
