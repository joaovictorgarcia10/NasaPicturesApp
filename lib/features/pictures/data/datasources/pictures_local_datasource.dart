import 'package:nasa_pictures_app/features/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/features/core/error/app_error.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';

class PicturesLocalDatasource implements PicturesDatasource {
  final LocalStorageClient localStorageClient;
  PicturesLocalDatasource({required this.localStorageClient});

  @override
  Future<List<Map<String, dynamic>>> getPictures() async {
    try {
      final response = localStorageClient.get(AppConstants.pictureListCacheKey);
      if (response.isNotEmpty) {
        return List.from(response);
      } else {
        throw AppError(type: AppErrorType.emptyData);
      }
    } catch (e) {
      rethrow;
    }
  }
}
