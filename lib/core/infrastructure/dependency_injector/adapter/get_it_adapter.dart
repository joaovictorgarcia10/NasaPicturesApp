import 'package:get_it/get_it.dart';
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/infrastructure/dependency_injector/dependency_injector.dart';

class GetItAdapter implements DependencyInjector {
  final GetIt getIt;

  GetItAdapter._({required this.getIt});
  static final GetItAdapter _singleton = GetItAdapter._(getIt: GetIt.I);
  factory GetItAdapter() => _singleton;

  @override
  void registerLazySingleton<T extends Object>(
      {required T instance, String? instanceName}) {
    try {
      getIt.registerLazySingleton<T>(
        () => instance,
        instanceName: instanceName,
      );
    } catch (e) {
      throw AppError(
        type: AppErrorType.dependencyInjector,
        exception: e,
      );
    }
  }

  @override
  T get<T extends Object>({String? instanceName}) {
    try {
      return getIt.get<T>(instanceName: instanceName);
    } catch (e) {
      throw AppError(
        type: AppErrorType.dependencyInjector,
        exception: e,
      );
    }
  }

  @override
  bool isRegistered<T extends Object>(
      {Object? instance, String? instanceName}) {
    try {
      return getIt.isRegistered<T>(
        instance: instance,
        instanceName: instanceName,
      );
    } catch (e) {
      throw AppError(
        type: AppErrorType.dependencyInjector,
        exception: e,
      );
    }
  }

  @override
  Future<void> reset() async {
    try {
      await getIt.reset();
    } catch (e) {
      throw AppError(
        type: AppErrorType.dependencyInjector,
        exception: e,
      );
    }
  }

  @override
  Future<void> unregister<T extends Object>({String? instanceName}) async {
    try {
      await getIt.unregister<T>(instanceName: instanceName);
    } catch (e) {
      throw AppError(
        type: AppErrorType.dependencyInjector,
        exception: e,
      );
    }
  }
}
