import 'package:nasa_pictures_app/features/core/error/app_error.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';

class PicturesRemoteDatasource implements PicturesDatasource {
  final HttpClient httpClient;
  PicturesRemoteDatasource({required this.httpClient});

  @override
  Future<List<Map<String, dynamic>>> getPictures() async {
    try {
      final response = await httpClient.request(
        method: "get",
        path: "/planetary/apod",
        queryParameters: {"count": "15"},
      );

      if (response.data != null && response.statusCode == 200) {
        return List.from(response.data);
      } else {
        throw AppError(type: AppErrorType.invalidData);
      }
    } catch (e) {
      rethrow;
    }
  }
}
