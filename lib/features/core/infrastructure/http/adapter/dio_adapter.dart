import 'package:dio/dio.dart';
import 'package:nasa_pictures_app/features/core/error/app_error.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/http_response.dart';

class DioAdapter implements HttpClient {
  final Dio dio;
  final String baseUrl;
  final Map<String, dynamic> queryParameters;

  DioAdapter({
    required this.dio,
    required this.baseUrl,
    required this.queryParameters,
  }) {
    _initialize();
  }

  void _initialize() {
    dio.options.baseUrl = baseUrl;
    dio.options.queryParameters = queryParameters;

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
      throw AppError(type: AppErrorType.httpResponse);
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
          throw AppError(type: AppErrorType.httpRequest);
      }

      return _handleResponse(response);
    } on DioException catch (e) {
      throw AppError(type: AppErrorType.httpRequest, exception: e);
    } catch (e) {
      throw AppError(type: AppErrorType.httpRequest, exception: e);
    }
  }
}
