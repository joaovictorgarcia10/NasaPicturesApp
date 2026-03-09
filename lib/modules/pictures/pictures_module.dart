import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/core/module_manager/module_contract.dart';
import 'package:nasa_pictures_app/core/module_manager/module_utils.dart';
import 'package:nasa_pictures_app/core/adapters/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/dependency_injector/dependency_injector.dart';
import 'package:nasa_pictures_app/core/adapters/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/core/controllers/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/pages/details/details_page.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/pages/home/home_page.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/pages/home/presenter/home_presenter.dart';
import 'package:nasa_pictures_app/modules/pictures/infrastructure/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/usecases/get_pictures_usecase.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/pages/home/presenter/home_presenter_impl.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_client.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/constants/pictures_constants.dart';

class PicturesModule implements ModuleContract {
  @override
  String get moduleName => "PicturesModule";

  @override
  DependencyInjector injector = GetItAdapter();

  @override
  void Function() get registerDependencies => () {
    injector
      ..registerFactory<HttpClient>(
        instance: DioAdapter(
          dio: Dio(),
          baseUrl: PicturesConstants.picturesBaseUrl,
          queryParameters: {"api_key": PicturesConstants.picturesApiKey},
        ),
        instanceName: 'PicturesHttpClient',
      )
      ..registerFactory<PicturesRemoteDatasource>(
        instance: PicturesRemoteDatasource(
          httpClient: injector.get<HttpClient>(
            instanceName: 'PicturesHttpClient',
          ),
        ),
      )
      ..registerFactory<PicturesLocalDatasource>(
        instance: PicturesLocalDatasource(
          localStorageClient: injector.get<LocalStorageClient>(),
        ),
      )
      ..registerFactory<PicturesRepository>(
        instance: PicturesRepositoryImpl(
          localDatasource: injector.get<PicturesLocalDatasource>(),
          remoteDatasource: injector.get<PicturesRemoteDatasource>(),
          networkConnectionController:
              injector.get<NetworkConnectionController>(),
        ),
      )
      ..registerFactory<GetPicturesUsecase>(
        instance: GetPicturesUsecase(
          repository: injector.get<PicturesRepository>(),
        ),
      )
      ..registerFactory<HomePresenter>(
        instance: HomePresenterImpl(
          getPicturesUsecase: injector.get<GetPicturesUsecase>(),
          networkConnectionController:
              injector.get<NetworkConnectionController>(),
        ),
      );
  };

  @override
  Map<String, WidgetBuilderArgs> get routes => {
    "/": (context, args) => HomePage(presenter: injector.get<HomePresenter>()),
    "/details":
        (context, args) => DetailsPage(
          picture: (args as Map<String, dynamic>)["picture"] as Picture,
        ),
  };
}
