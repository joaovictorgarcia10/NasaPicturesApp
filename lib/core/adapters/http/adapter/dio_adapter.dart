import 'package:dio/dio.dart';

import 'package:nasa_pictures_app/core/adapters/http/http_client.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_method.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_response.dart';

class DioAdapter implements HttpClient {
  final Dio dio;
  final String baseUrl;
  final Map<String, dynamic>? queryParameters;
  final List<Interceptor>? interceptors;

  DioAdapter({
    required this.dio,
    required this.baseUrl,
    this.queryParameters,
    this.interceptors,
  }) {
    _initialize();
  }

  void _initialize() {
    dio.options.baseUrl = baseUrl;
    dio.options.queryParameters = queryParameters ?? {};

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

    dio.interceptors.addAll(interceptors ?? []);
  }

  HttpResponse _handleResponse(Response response) {
    final data = response.data;

    if (data == null) {
      throw Exception('HTTP response error: status ${response.statusCode}');
    } else {
      return HttpResponse(data: data);
    }
  }

  @override
  Future<HttpResponse> request({
    required HttpMethod method,
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
  }) async {
    late Response response;
    final jsonBody = (body != null) ? body : null;

    try {
      switch (method) {
        case HttpMethod.post:
          response = await dio.post(
            path,
            queryParameters: queryParameters,
            data: jsonBody,
          );

        case HttpMethod.get:
          response = await dio.get(path, queryParameters: queryParameters);

        case HttpMethod.patch:
          response = await dio.patch(
            path,
            queryParameters: queryParameters,
            data: jsonBody,
          );

        case HttpMethod.put:
          response = await dio.put(
            path,
            queryParameters: queryParameters,
            data: jsonBody,
          );

        case HttpMethod.delete:
          response = await dio.delete(
            path,
            queryParameters: queryParameters,
            data: jsonBody,
          );
      }

      return _handleResponse(response);
    } on DioException catch (e, s) {
      Error.throwWithStackTrace(
        Exception('Network request failed: ${e.message}'),
        s,
      );
    } catch (e, s) {
      Error.throwWithStackTrace(e, s);
    }
  }
}
