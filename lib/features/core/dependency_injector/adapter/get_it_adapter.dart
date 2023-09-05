import 'package:get_it/get_it.dart';
import 'package:nasa_pictures_app/features/core/dependency_injector/dependency_injector.dart';

class GetItAdapter implements DependencyInjector {
  final GetIt getIt;

  GetItAdapter._({required this.getIt});
  static final GetItAdapter _singleton = GetItAdapter._(getIt: GetIt.I);
  factory GetItAdapter() => _singleton;

  @override
  void registerLazySingleton<T extends Object>(
      {required T instance, String? instanceName}) {
    getIt.registerLazySingleton<T>(() => instance, instanceName: instanceName);
  }

  @override
  T get<T extends Object>({String? instanceName}) {
    return getIt.get<T>(instanceName: instanceName);
  }

  @override
  bool isRegistered<T extends Object>(
      {Object? instance, String? instanceName}) {
    return getIt.isRegistered<T>(
      instance: instance,
      instanceName: instanceName,
    );
  }

  @override
  Future<void> reset() async => await getIt.reset();

  @override
  Future<void> unregister<T extends Object>({String? instanceName}) async {
    await getIt.unregister<T>(instanceName: instanceName);
  }
}
