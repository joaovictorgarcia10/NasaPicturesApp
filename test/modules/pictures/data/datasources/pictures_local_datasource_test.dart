import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/core/adapters/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/modules/pictures/infrastructure/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';

import '../../mock/picture_list_mock.dart';

class LocalStorageClientMock extends Mock implements LocalStorageClient {}

void main() {
  late PicturesDatasource sut;
  late LocalStorageClient localStorageClient;

  setUp(() {
    localStorageClient = LocalStorageClientMock();
    sut = PicturesLocalDatasource(localStorageClient: localStorageClient);
  });

  group("PicturesLocalDatasource Test", () {
    test(
      "Should return a list of pictures from local storage client",
      () async {
        when(
          () => localStorageClient.getList(AppConstants.pictureListCacheKey),
        ).thenAnswer((_) => pictureLisMock);

        final response = await sut.getPictures();

        expect(response.length, 2);
        expect(response.last["title"], "NGC 7635: The Bubble Nebula Expanding");

        verify(
          () => localStorageClient.getList(AppConstants.pictureListCacheKey),
        );
      },
    );

    test(
      "Should throw an Exception when local storage returns empty list",
      () async {
        when(
          () => localStorageClient.getList(AppConstants.pictureListCacheKey),
        ).thenAnswer((_) => []);

        expect(() => sut.getPictures(), throwsA(isA<Exception>()));

        verify(
          () => localStorageClient.getList(AppConstants.pictureListCacheKey),
        );
      },
    );

    test("Should propagate Exception from local storage client", () async {
      when(
        () => localStorageClient.getList(AppConstants.pictureListCacheKey),
      ).thenThrow(Exception('storage failure'));

      expect(() => sut.getPictures(), throwsA(isA<Exception>()));

      verify(
        () => localStorageClient.getList(AppConstants.pictureListCacheKey),
      );
    });
  });
}
