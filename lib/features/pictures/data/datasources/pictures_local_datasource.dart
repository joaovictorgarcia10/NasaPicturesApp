import 'package:nasa_pictures_app/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';

class PicturesLocalDatasource implements PicturesDatasource {
  final LocalStorageClient localStorageClient;
  PicturesLocalDatasource({required this.localStorageClient});

  @override
  Future<List<Map<String, dynamic>>> getPictures() async {
    try {
      final response = localStorageClient.get(AppConstants.pictureListCacheKey);
      final List<Map<String, dynamic>> data = List.from(response);

      if (data.isNotEmpty) {
        return data;
      } else {
        throw AppError(type: AppErrorType.invalidData);
      }
    } catch (e) {
      throw AppError(type: AppErrorType.datasource, exception: e);
    }
  }
}
