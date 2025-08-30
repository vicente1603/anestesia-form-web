typedef FactoryFunc<T> = T Function();

abstract class InjectorInterface {
  void registerFactory<T extends Object>(T instance, {String? name});
  void registerLazySingleton<T extends Object>(T instance);
  void registerSingleton<T extends Object>(T instance);
  T get<T extends Object>();
  void unregister<T extends Object>();
  bool isRegistered<T extends Object>({Object? instance, String? instanceName});
  Future<void> reset();
}
