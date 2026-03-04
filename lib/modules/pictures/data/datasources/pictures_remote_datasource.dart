import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';

class PicturesRemoteDatasource implements PicturesDatasource {
  final HttpClient httpClient;
  final PicturesLocalDatasource localDatasource;

  PicturesRemoteDatasource({
    required this.httpClient,
    required this.localDatasource,
  });

  @override
  Future<List<Map<String, dynamic>>> getPictures({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParameters;

      if (date != null) {
        queryParameters = {"date": date};
      } else if (startDate != null && endDate != null) {
        queryParameters = {"start_date": startDate, "end_date": endDate};
      } else {
        queryParameters = {"count": "15"};
      }

      final response = await httpClient.request(
        method: "get",
        path: "/planetary/apod",
        queryParameters: queryParameters,
      );

      final rawData = response.data;

      final List<Map<String, dynamic>> data =
          rawData is List
              ? List<Map<String, dynamic>>.from(rawData)
              : [rawData as Map<String, dynamic>];

      if (data.isNotEmpty) {
        localDatasource.savePictures(pictures: data);
        return data;
      } else {
        throw AppError(type: AppErrorType.invalidData);
      }
    } on AppError catch (_) {
      rethrow;
    } catch (e) {
      throw AppError(type: AppErrorType.datasource, exception: e);
    }
  }
}
