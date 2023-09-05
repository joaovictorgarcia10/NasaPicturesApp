import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/features/core/infra/http/http_client.dart';
import 'package:nasa_pictures_app/features/core/infra/http/http_response.dart';

class DioAdapter implements HttpClient {
  final Dio dio;
  final String apiEndpoint;
  final String apiKey;

  DioAdapter({
    required this.dio,
    required this.apiEndpoint,
    required this.apiKey,
  }) {
    _init();
  }

  void _init() {
    dio.options.baseUrl = apiEndpoint;
    dio.options.queryParameters = {"api_key": apiKey};

    dio.options.headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        responseBody: true,
      ),
    );
  }

  HttpResponse _handleResponse(Response response) {
    final data = response.data;
    final statusCode = response.statusCode;

    if (data == null || statusCode == null) {
      throw Exception(); // Http Response Exception
    } else {
      return HttpResponse(
        data: data,
        statusCode: statusCode,
      );
    }
  }

  @override
  Future<HttpResponse> request({
    required String method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    late Response response;
    final jsonBody = (body != null) ? body : null;

    try {
      switch (method) {
        case 'post':
          response = await dio.post(path,
              queryParameters: queryParameters, data: jsonBody);
        case 'get':
          response = await dio.get(path, queryParameters: queryParameters);
        case 'patch':
          response = await dio.patch(path,
              queryParameters: queryParameters, data: jsonBody);
        case 'delete':
          response = await dio.delete(path,
              queryParameters: queryParameters, data: jsonBody);
        default:
          throw Exception();
      }

      return _handleResponse(response);
    } on DioException catch (_) {
      throw Exception(); // Dio Exception
    } catch (e) {
      throw Exception(); // Http Request Exception
    }
  }
}
