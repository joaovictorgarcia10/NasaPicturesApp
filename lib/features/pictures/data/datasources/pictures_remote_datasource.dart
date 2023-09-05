import 'package:nasa_pictures_app/features/core/infra/http/http_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';

class PicturesRemoteDatasource extends PicturesDatasource {
  final HttpClient httpClient;
  PicturesRemoteDatasource({required this.httpClient});

  @override
  Future<List<dynamic>> getAllPictures() async {
    try {
      final response = await httpClient.request(
        method: "get",
        path: "/planetary/apod",
        queryParameters: {
          "start_date": "2023-08-04",
          "end_date": "2023-09-04",
        },
      );

      if (response.data != null && response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(); // Invalid Data Exception
      }
    } catch (e) {
      rethrow;
    }
  }
}
