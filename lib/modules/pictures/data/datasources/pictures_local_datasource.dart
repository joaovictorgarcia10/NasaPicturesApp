import 'package:nasa_pictures_app/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/modules/pictures/infrastructure/datasources/pictures_datasource.dart';

class PicturesLocalDatasource implements PicturesDatasource {
  final LocalStorageClient localStorageClient;

  PicturesLocalDatasource({required this.localStorageClient});

  @override
  Future<List<Map<String, dynamic>>> getPictures({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    final response = localStorageClient.getList(
      AppConstants.pictureListCacheKey,
    );

    final List<Map<String, dynamic>> data = List.from(response);

    if (data.isNotEmpty) {
      return data;
    } else {
      throw Exception('No data found in local storage');
    }
  }

  Future<bool> savePictures({
    required List<Map<String, dynamic>> pictures,
  }) async {
    try {
      await localStorageClient.saveList(
        AppConstants.pictureListCacheKey,
        pictures,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
