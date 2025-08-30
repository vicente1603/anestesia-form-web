import 'package:anestesia_web/src/infra/infra.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'module.dart';

class ModuleManager implements ModuleManagerInterface {
  Map<String, WidgetBuilder>? _routes;
  List<SingleChildWidget>? _providers;
  ModuleManager() {
    _routes = {};
    _providers = [];
  }
  @override
  Map<String, WidgetBuilder>? get routes => _routes;
  @override
  List<SingleChildWidget>? get providers => _providers;
  @override
  Future<void> registerModules(List<ModuleInterface> modules) async {
    for (ModuleInterface module in modules) {
      try {
        await module.registerServices(Injector.instance);
      } catch (e) {
        print(e);
      }
      if (module.providers(Injector.instance) != null) {
        _providers!.addAll(module.providers(Injector.instance) ?? []);
      }
      if (module.routes() != null) {
        _routes!.addAll(module.routes()!);
      }
    }
  }
}
