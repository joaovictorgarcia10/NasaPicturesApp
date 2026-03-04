import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/core/adapters/http/adapter/dio_adapter.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_client.dart';

void main() {
  late HttpClient sut;

  setUp(() {
    sut = DioAdapter(dio: Dio(), baseUrl: "https://dart.dev");
  });

  group("DioAdapter Tests", () {
    test("Should throw an Exception for an invalid HTTP method", () async {
      await expectLater(
        () => sut.request(method: "find", path: "/"),
        throwsA(isA<Exception>()),
      );
    });

    test("Should do a GET request and return the expected values", () async {
      final response = await sut.request(method: "get", path: "/");
      expect(response.data, isNotNull);
    });

    test("Should do a POST request and return the expected values", () async {
      final response = await sut.request(method: "post", path: "/");
      expect(response.data, isNotNull);
    });

    test("Should do a PATCH request and return the expected values", () async {
      final response = await sut.request(method: "patch", path: "/");
      expect(response.data, isNotNull);
    });

    test("Should do a DELETE request and return the expected values", () async {
      final response = await sut.request(method: "delete", path: "/");
      expect(response.data, isNotNull);
    });
  });
}
