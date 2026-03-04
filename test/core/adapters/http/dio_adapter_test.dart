import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/core/adapters/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_client.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_method.dart';

void main() {
  late HttpClient sut;

  setUp(() {
    sut = DioAdapter(dio: Dio(), baseUrl: "https://dart.dev");
  });

  group("DioAdapter Tests", () {
    test("Should do a GET request and return the expected values", () async {
      final response = await sut.request(method: HttpMethod.get, path: "/");
      expect(response.data, isNotNull);
    });

    test("Should do a POST request and return the expected values", () async {
      final response = await sut.request(method: HttpMethod.post, path: "/");
      expect(response.data, isNotNull);
    });

    test("Should do a PATCH request and return the expected values", () async {
      final response = await sut.request(method: HttpMethod.patch, path: "/");
      expect(response.data, isNotNull);
    });

    test("Should do a PUT request and return the expected values", () async {
      final response = await sut.request(method: HttpMethod.put, path: "/");
      expect(response.data, isNotNull);
    });

    test("Should do a DELETE request and return the expected values", () async {
      final response = await sut.request(method: HttpMethod.delete, path: "/");
      expect(response.data, isNotNull);
    });
  });
}
