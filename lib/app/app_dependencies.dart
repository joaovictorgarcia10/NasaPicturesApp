import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/home_presenter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nasa_pictures_app/features/core/dependency_injector/dependency_injector.dart';
import 'package:nasa_pictures_app/features/core/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/adapter/shared_preferences_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_all_pictures_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/presentation/home/home_presenter_impl.dart';

class AppDependencies {
  final DependencyInjector injector = GetItAdapter();

  Future<void> registerAppDependencies() async {
    // Http Client
    injector.registerLazySingleton<HttpClient>(
      instance: DioAdapter(
        dio: Dio(),
        baseUrl: const String.fromEnvironment("API_ENDPOINT"),
        queryParameters: {"api_key": const String.fromEnvironment("API_KEY")},
      ),
    );

    // Local Storage Client
    injector.registerLazySingleton<LocalStorageClient>(
      instance: SharedPreferencesAdapter(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    );

    // Datasources
    injector.registerLazySingleton<PicturesDatasource>(
      instance: PicturesRemoteDatasource(
        httpClient: injector.get<HttpClient>(),
      ),
    );

    // Repositorys
    injector.registerLazySingleton<PicturesRepository>(
      instance: PicturesRepositoryImpl(
        datasource: injector.get<PicturesDatasource>(),
      ),
    );

    // Usecases
    injector.registerLazySingleton<GetAllPicturesUsecase>(
        instance: GetAllPicturesUsecase(
            repository: injector.get<PicturesRepository>()));

    // Presenters
    injector.registerLazySingleton<HomePresenter>(
        instance: HomePresenterImpl(
            getAllPicturesUsecase: injector.get<GetAllPicturesUsecase>()));
  }
}
