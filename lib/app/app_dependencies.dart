import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/interceptors/local_storage_dio_interceptor.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/check_internet_connection_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/home_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/dependency_injector/dependency_injector.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_all_pictures_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/presentation/home/home_presenter_impl.dart';

class AppDependencies {
  final DependencyInjector injector = GetItAdapter();

  Future<void> registerAppDependencies() async {
    // Local Storage Client
    injector.registerLazySingleton<LocalStorageClient>(
      instance: SharedPreferencesAdapter(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    );

    // Local Storage Dio Interceptor
    injector.registerLazySingleton<LocalStorageDioInterceptor>(
      instance: LocalStorageDioInterceptor(
        localStorageClient: injector.get<LocalStorageClient>(),
      ),
    );

    // Http Client
    injector.registerLazySingleton<HttpClient>(
      instance: DioAdapter(
        dio: Dio(),
        baseUrl: const String.fromEnvironment("API_ENDPOINT"),
        queryParameters: {"api_key": const String.fromEnvironment("API_KEY")},
        interceptors: [injector.get<LocalStorageDioInterceptor>()],
      ),
    );

    // Datasources
    injector.registerLazySingleton<PicturesLocalDatasource>(
      instance: PicturesLocalDatasource(
        localStorageClient: injector.get<LocalStorageClient>(),
      ),
    );

    injector.registerLazySingleton<PicturesRemoteDatasource>(
      instance: PicturesRemoteDatasource(
        httpClient: injector.get<HttpClient>(),
      ),
    );

    // Repositorys
    injector.registerLazySingleton<PicturesRepository>(
      instance: PicturesRepositoryImpl(
        localDatasource: injector.get<PicturesLocalDatasource>(),
        remoteDatasource: injector.get<PicturesRemoteDatasource>(),
      ),
    );

    // Usecases
    injector.registerLazySingleton<CheckInternetConnectionUsecase>(
        instance: CheckInternetConnectionUsecase());

    injector.registerLazySingleton<GetAllPicturesUsecase>(
      instance: GetAllPicturesUsecase(
        repository: injector.get<PicturesRepository>(),
        checkInternetConnection: injector.get<CheckInternetConnectionUsecase>(),
      ),
    );

    // Presenters
    injector.registerLazySingleton<HomePresenter>(
      instance: HomePresenterImpl(
        getAllPicturesUsecase: injector.get<GetAllPicturesUsecase>(),
        checkInternetConnectionUsecase:
            injector.get<CheckInternetConnectionUsecase>(),
      ),
    );
  }
}
