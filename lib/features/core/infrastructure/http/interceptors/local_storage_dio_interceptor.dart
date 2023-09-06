import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/features/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';

class LocalStorageDioInterceptor extends Interceptor {
  final LocalStorageClient localStorageClient;

  LocalStorageDioInterceptor({
    required this.localStorageClient,
  });

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.method == "GET" &&
        response.requestOptions.path == "/planetary/apod") {
      final currentList =
          localStorageClient.getPictures(AppConstants.pictureListCacheKey);

      if (currentList.length < AppConstants.pictureListMaxLenght) {
        _incrementCache(
          currentList: List.from(currentList),
          incrementalList: List.from(response.data),
        );
      }
    }

    handler.resolve(response);
  }

  void _incrementCache({
    required List<Map<String, dynamic>> currentList,
    required List<Map<String, dynamic>> incrementalList,
  }) {
    final newList = <Map<String, dynamic>>[...currentList, ...incrementalList];
    localStorageClient.setPictures(AppConstants.pictureListCacheKey, newList);
  }
}
