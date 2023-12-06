import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/core/infrastructure/network_connection/adapter/connectivity_plus_adapter.dart';
import 'package:nasa_pictures_app/core/infrastructure/network_connection/network_connection_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nasa_pictures_app/core/environment/app_environment.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_presenter.dart';
import 'package:nasa_pictures_app/core/infrastructure/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/core/infrastructure/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/core/infrastructure/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/modules/pictures/data/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/usecases/get_pictures_usecase.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_presenter_impl.dart';

class AppDependencies {
  final injector = GetItAdapter();

  Future<void> registerAppDependencies() async {
    // Local Storage Client
    injector.registerLazySingleton<LocalStorageClient>(
      instance: SharedPreferencesAdapter(
        sharedPreferences: await SharedPreferences.getInstance(),
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

    // Network Connection
    injector.registerLazySingleton<NetworkConnectionClient>(
      instance: ConnectivityPlusAdapter(),
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
        networkConnectionClient: injector.get<NetworkConnectionClient>(),
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
        networkConnectionClient: injector.get<NetworkConnectionClient>(),
      ),
    );
  }
}
