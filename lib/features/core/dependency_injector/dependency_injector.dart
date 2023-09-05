abstract interface class DependencyInjector {
  void registerLazySingleton<T extends Object>({
    required T instance,
    String? instanceName,
  });

  T get<T extends Object>({String? instanceName});

  Future<void> unregister<T extends Object>({String? instanceName});

  bool isRegistered<T extends Object>({
    Object? instance,
    String? instanceName,
  });

  Future<void> reset();
}
