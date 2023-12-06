import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/core/infrastructure/http/http_response.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_remote_datasource.dart';

import '../../mock/picture_list_mock.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  late PicturesDatasource sut;
  late HttpClient httpClient;

  setUp(() {
    httpClient = HttpClientMock();
    sut = PicturesRemoteDatasource(httpClient: httpClient);
  });

  group("PicturesRemoteDatasource Tests", () {
    test("Should return a list of pictures from http client", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      ).thenAnswer(
        (_) => Future.value(HttpResponse(data: pictureLisMock)),
      );

      final response = await sut.getPictures();

      expect(response.length, 2);
      expect(response.last["title"], "NGC 7635: The Bubble Nebula Expanding");

      verify(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      );
    });

    test("Should throw an AppError invalidData", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      ).thenAnswer(
        (_) => Future.value(HttpResponse(data: [])),
      );

      try {
        await sut.getPictures();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.invalidData);
      }

      verify(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      );
    });

    test("Should throw an AppError httpRequest", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      ).thenThrow(AppError(type: AppErrorType.httpRequest));

      try {
        await sut.getPictures();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.httpRequest);
      }

      verify(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      );
    });

    test("Should throw an AppError httpResponse", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      ).thenThrow(AppError(type: AppErrorType.httpResponse));

      try {
        await sut.getPictures();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.httpResponse);
      }

      verify(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      );
    });
  });
}
