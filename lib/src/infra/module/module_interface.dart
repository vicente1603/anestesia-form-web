import 'dart:async';
import 'package:anestesia_web/src/infra/infra.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

import '../../features/features.dart';
part '../binds.dart';
part '../routes.dart';

abstract class ModuleInterface {
  Map<String, WidgetBuilder>? routes();
  List<SingleChildWidget>? providers(Injector injector);
  FutureOr<void> registerServices(Injector injector);
}
