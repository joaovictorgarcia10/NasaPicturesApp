import 'package:nasa_pictures_app/features/core/infrastructure/http/http_response.dart';

abstract class HttpClient {
  Future<HttpResponse> request({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  });
}
