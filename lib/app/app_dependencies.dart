import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/features/core/dependency_injector/dependency_injector.dart';
import 'package:nasa_pictures_app/features/core/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/features/core/infra/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/features/core/infra/http/http_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_all_pictures_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/presentation/presenters/home/home_presenter_impl.dart';
import 'package:nasa_pictures_app/features/pictures/ui/pages/home/home_presenter.dart';

class AppDependencies {
  final DependencyInjector injector = GetItAdapter();

  void registerAppDependencies() {
    // Http Client
    injector.registerLazySingleton<HttpClient>(
      instance: DioAdapter(
        dio: Dio(),
        apiEndpoint: const String.fromEnvironment("API_ENDPOINT"),
        apiKey: const String.fromEnvironment("API_KEY"),
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
