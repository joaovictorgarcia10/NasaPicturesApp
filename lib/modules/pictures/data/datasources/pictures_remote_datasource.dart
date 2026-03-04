import 'package:nasa_pictures_app/core/adapters/http/http_client.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_method.dart';
import 'package:nasa_pictures_app/modules/pictures/infrastructure/datasources/pictures_datasource.dart';

class PicturesRemoteDatasource extends PicturesDatasource {
  final HttpClient httpClient;

  PicturesRemoteDatasource({required this.httpClient});

  @override
  Future<List<Map<String, dynamic>>> getPictures({
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    final queryParameters = _handleQueryParameters(
      date: date,
      startDate: startDate,
      endDate: endDate,
    );

    final response = await httpClient.request(
      method: HttpMethod.get,
      path: "/planetary/apod",
      queryParameters: queryParameters,
    );

    final List<Map<String, dynamic>> data =
        response.data is List
            ? List<Map<String, dynamic>>.from(response.data)
            : [response.data as Map<String, dynamic>];

    if (data.isNotEmpty) {
      return data;
    } else {
      throw Exception('No data found in remote datasource');
    }
  }

  Map<String, dynamic> _handleQueryParameters({
    String? date,
    String? startDate,
    String? endDate,
  }) {
    if (date != null) {
      return {"date": date};
    } else if (startDate != null && endDate != null) {
      return {"start_date": startDate, "end_date": endDate};
    } else {
      return {"count": "15"};
    }
  }
}
