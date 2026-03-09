import 'package:nasa_pictures_app/core/controllers/network_connection/network_connection_controller.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesWithCache, SharedPreferencesWithCacheOptions;
import 'package:nasa_pictures_app/core/adapters/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/local_storage_client.dart';

class AppDependencies {
  final injector = GetItAdapter();

  Future<void> registerAppDependencies() async {
    // Local Storage Client
    injector.registerLazySingleton<LocalStorageClient>(
      instance: SharedPreferencesAdapter(
        sharedPreferences: await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(),
        ),
      ),
    );

    // Network Connection Controller
    injector.registerLazySingleton<NetworkConnectionController>(
      instance: NetworkConnectionController(),
    );
  }
}
