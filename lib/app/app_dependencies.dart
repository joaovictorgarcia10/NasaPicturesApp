import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferencesWithCache, SharedPreferencesWithCacheOptions;
import 'package:nasa_pictures_app/core/utils/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/core/environment/app_environment.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/presenter/home_presenter.dart';
import 'package:nasa_pictures_app/core/adapters/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_client.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/modules/pictures/infrastructure/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/usecases/get_pictures_usecase.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/presenter/home_presenter_impl.dart';

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

    // Http Client
    injector.registerLazySingleton<HttpClient>(
      instance: DioAdapter(
        dio: Dio(),
        baseUrl: AppEnvironment.apiBaseUrl,
        queryParameters: {"api_key": AppEnvironment.apiKey},
      ),
    );

    // Network Connection Controller
    injector.registerLazySingleton<NetworkConnectionController>(
      instance: NetworkConnectionController(),
    );

    // Datasources
    injector.registerLazySingleton<PicturesLocalDatasource>(
      instanceName: "PicturesLocalDatasource",
      instance: PicturesLocalDatasource(
        localStorageClient: injector.get<LocalStorageClient>(),
      ),
    );

    injector.registerLazySingleton<PicturesRemoteDatasource>(
      instanceName: "PicturesRemoteDatasource",
      instance: PicturesRemoteDatasource(
        httpClient: injector.get<HttpClient>(),
      ),
    );

    // Repositories
    injector.registerLazySingleton<PicturesRepository>(
      instance: PicturesRepositoryImpl(
        localDatasource: injector.get<PicturesLocalDatasource>(
          instanceName: "PicturesLocalDatasource",
        ),
        remoteDatasource: injector.get<PicturesRemoteDatasource>(
          instanceName: "PicturesRemoteDatasource",
        ),
        networkConnectionController:
            injector.get<NetworkConnectionController>(),
      ),
    );

    // Usecases
    injector.registerLazySingleton<GetPicturesUsecase>(
      instance: GetPicturesUsecase(
        repository: injector.get<PicturesRepository>(),
      ),
    );

    // Presenters
    injector.registerLazySingleton<HomePresenter>(
      instance: HomePresenterImpl(
        getPicturesUsecase: injector.get<GetPicturesUsecase>(),
        networkConnectionController:
            injector.get<NetworkConnectionController>(),
      ),
    );
  }
}
