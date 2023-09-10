import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/features/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/features/core/environment/app_environment.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';

class LocalStorageDioInterceptor extends Interceptor {
  final LocalStorageClient localStorageClient;
  LocalStorageDioInterceptor({required this.localStorageClient});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.baseUrl == AppEnvironment.apiBaseUrl &&
        response.requestOptions.method == "GET" &&
        response.requestOptions.path == "/planetary/apod") {
      final currentList =
          localStorageClient.get(AppConstants.pictureListCacheKey);

      if (currentList.length < AppConstants.pictureListMaxLenght) {
        final newList = <Map<String, dynamic>>[
          ...List.from(currentList),
          ...List.from(response.data),
        ];

        localStorageClient.save(AppConstants.pictureListCacheKey, newList);
      } else {
        localStorageClient.clear(AppConstants.pictureListCacheKey);
      }
    }

    handler.resolve(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final currentList =
        localStorageClient.get(AppConstants.pictureListCacheKey);

    handler.resolve(
      Response(
        requestOptions: err.requestOptions,
        data: currentList,
      ),
    );
  }
}
