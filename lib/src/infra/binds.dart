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

    i.registerFactory<AuthRepository>(
      FirebaseAuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
    );

    i.registerFactory<SecretariesRepository>(
      SecretariesRepositoryImpl(FirebaseFirestore.instance, i.get()),
    );

    i.registerFactory<DoctorRepository>(
      DoctorRepositoryImpl(FirebaseFirestore.instance),
    );

    i.registerFactory<PatientsRepository>(
      PatientsRepositoryImpl(FirebaseFirestore.instance),
    );

    i.registerFactory<LoginPresenter>(LoginPresenter(authRepository: i.get()));

    i.registerFactory<SecretariesPresenter>(
      SecretariesPresenter(
        authRepository: i.get(),
        secretariesRepository: i.get(),
      ),
    );

    i.registerFactory<DoctorPresenter>(
      DoctorPresenter(
        doctorRepository: i.get(),
        secretariesRepository: i.get(),
        authRepository: i.get(),
      ),
    );

    i.registerFactory<PatientsPresenter>(
      PatientsPresenter(
        doctorRepository: i.get(),
        secretariesRepository: i.get(),
        authRepository: i.get(),
        patientsRepository: i.get(),
      ),
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
