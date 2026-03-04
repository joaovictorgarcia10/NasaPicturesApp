import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_client.dart';
import 'package:nasa_pictures_app/core/adapters/http/http_response.dart';
import 'package:nasa_pictures_app/modules/pictures/infrastructure/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_remote_datasource.dart';

import '../../mock/picture_list_mock.dart';

class HttpClientMock extends Mock implements HttpClient {}

class PicturesLocalDatasourceMock extends Mock
    implements PicturesLocalDatasource {}

void main() {
  late PicturesDatasource sut;
  late HttpClient httpClient;
  late PicturesLocalDatasource localDatasource;

  setUp(() {
    httpClient = HttpClientMock();
    localDatasource = PicturesLocalDatasourceMock();
    sut = PicturesRemoteDatasource(
      httpClient: httpClient,
      localDatasource: localDatasource,
    );
  });

  group("PicturesRemoteDatasource Tests", () {
    test("Should return a list of pictures from http client", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      ).thenAnswer((_) => Future.value(HttpResponse(data: pictureLisMock)));

      when(
        () => localDatasource.savePictures(pictures: pictureLisMock),
      ).thenAnswer((_) async => true);

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

    test("Should throw an Exception when API returns empty list", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      ).thenAnswer((_) => Future.value(HttpResponse(data: [])));

      expect(() => sut.getPictures(), throwsA(isA<Exception>()));

      verify(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"count": "15"},
        ),
      );
    });

    test(
      "Should propagate Exception from http client on network failure",
      () async {
        when(
          () => httpClient.request(
            method: "get",
            path: "/planetary/apod",
            queryParameters: {"count": "15"},
          ),
        ).thenThrow(Exception('Network request failed'));

        await expectLater(() => sut.getPictures(), throwsA(isA<Exception>()));

        verify(
          () => httpClient.request(
            method: "get",
            path: "/planetary/apod",
            queryParameters: {"count": "15"},
          ),
        );
      },
    );

    test(
      "Should propagate Exception from http client on response error",
      () async {
        when(
          () => httpClient.request(
            method: "get",
            path: "/planetary/apod",
            queryParameters: {"count": "15"},
          ),
        ).thenThrow(Exception('HTTP response error'));

        await expectLater(() => sut.getPictures(), throwsA(isA<Exception>()));

        verify(
          () => httpClient.request(
            method: "get",
            path: "/planetary/apod",
            queryParameters: {"count": "15"},
          ),
        );
      },
    );

    test("Should use date queryParameter when date is provided", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"date": "2026-03-03"},
        ),
      ).thenAnswer((_) => Future.value(HttpResponse(data: pictureSingleMock)));

      when(
        () => localDatasource.savePictures(pictures: [pictureSingleMock]),
      ).thenAnswer((_) async => true);

      final response = await sut.getPictures(date: "2026-03-03");

      expect(response.length, 1);
      expect(
        response.first["title"],
        "M13: The Great Globular Cluster in Hercules",
      );
      verify(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"date": "2026-03-03"},
        ),
      );
    });

    test("Should normalize single Map response into a list of 1", () async {
      when(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"date": "2007-05-18"},
        ),
      ).thenAnswer((_) => Future.value(HttpResponse(data: pictureSingleMock)));

      when(
        () => localDatasource.savePictures(pictures: [pictureSingleMock]),
      ).thenAnswer((_) async => true);

      final response = await sut.getPictures(date: "2007-05-18");

      expect(response, isA<List<Map<String, dynamic>>>());
      expect(response.length, 1);
      expect(
        response.first["title"],
        "M13: The Great Globular Cluster in Hercules",
      );

      verify(
        () => httpClient.request(
          method: "get",
          path: "/planetary/apod",
          queryParameters: {"date": "2007-05-18"},
        ),
      );
    });

    test(
      "Should use start_date/end_date queryParameters when range is provided",
      () async {
        when(
          () => httpClient.request(
            method: "get",
            path: "/planetary/apod",
            queryParameters: {
              "start_date": "2024-01-01",
              "end_date": "2024-01-31",
            },
          ),
        ).thenAnswer((_) => Future.value(HttpResponse(data: pictureLisMock)));

        when(
          () => localDatasource.savePictures(pictures: pictureLisMock),
        ).thenAnswer((_) async => true);

        final response = await sut.getPictures(
          startDate: "2024-01-01",
          endDate: "2024-01-31",
        );

        expect(response.length, 2);
        verify(
          () => httpClient.request(
            method: "get",
            path: "/planetary/apod",
            queryParameters: {
              "start_date": "2024-01-01",
              "end_date": "2024-01-31",
            },
          ),
        );
      },
    );
  });
}
