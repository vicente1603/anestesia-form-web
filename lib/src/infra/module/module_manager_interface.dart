import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import 'module.dart';

abstract class ModuleManagerInterface {
  Future<void> registerModules(List<ModuleInterface> modules);
  Map<String, WidgetBuilder>? get routes;
  List<SingleChildWidget>? get providers;
}
