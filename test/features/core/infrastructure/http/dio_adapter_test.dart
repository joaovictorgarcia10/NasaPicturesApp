import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/http/http_client.dart';

void main() {
  late HttpClient sut;

  setUp(() {
    sut = DioAdapter(dio: Dio(), baseUrl: "", queryParameters: {});
  });
}
