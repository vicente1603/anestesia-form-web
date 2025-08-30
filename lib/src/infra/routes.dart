part of 'module/module_interface.dart';

abstract class Routes {
  static Map<String, WidgetBuilder> routes(Injector i) => {
    '/patient-form': (context) => PatientFormPage(presenter: i.get()),
  };
}
