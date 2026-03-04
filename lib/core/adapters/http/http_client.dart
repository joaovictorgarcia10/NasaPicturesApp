import 'package:nasa_pictures_app/core/adapters/http/http_method.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_response.dart';

abstract class HttpClient {
  Future<HttpResponse> request({
    required HttpMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  });
}
