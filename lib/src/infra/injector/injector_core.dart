import 'package:get_it/get_it.dart';

import 'injector_interface.dart';

class Injector implements InjectorInterface {
  static Injector? _instance;
  late GetIt _getIt;

  static Injector get instance {
    _instance ??= Injector._();
    return _instance!;
  }

  Injector._() {
    _getIt = GetIt.instance;
  }

  @override
  T get<T extends Object>({String? name}) {
    return _getIt.get<T>(instanceName: name);
  }

  @override
  void registerFactory<T extends Object>(
    T instance, {
    String? name,
  }) {
    _getIt.registerFactory(
      () => instance,
      instanceName: name,
    );
  }

  @override
  void registerLazySingleton<T extends Object>(
    T instance, {
    String? name,
  }) {
    _getIt.registerLazySingleton<T>(
      () => instance,
      instanceName: name,
    );
  }

  @override
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  @override
  void unregister<T extends Object>({
    Function(T)? disposingFunction,
    String? name,
  }) {
    _getIt.unregister<T>(
      disposingFunction: disposingFunction,
      instanceName: name,
    );
  }

  @override
  bool isRegistered<T extends Object>({
    Object? instance,
    String? instanceName,
  }) {
    return _getIt.isRegistered<T>(
      instance: instance,
      instanceName: instanceName,
    );
  }

  @override
  Future<void> reset() async {
    await _getIt.reset();
  }
}

final DM = Injector.instance;
