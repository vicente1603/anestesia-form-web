import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import '../infra.dart';

class AppModule implements ModuleInterface {
  @override
  List<SingleChildWidget>? providers(Injector injector) => null;

  @override
  void registerServices(Injector i) => AppBinds.binds(i);

  @override
  Map<String, WidgetBuilder> routes() => Routes.routes(Injector.instance);
}
