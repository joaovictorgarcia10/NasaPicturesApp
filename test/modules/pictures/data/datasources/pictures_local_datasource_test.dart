import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/constants/app_constants.dart';
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/infrastructure/local_storage/local_storage_client.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_datasource.dart';
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
    test("Should return a list of pictures from local storage client",
        () async {
      when(() => localStorageClient.getList(AppConstants.pictureListCacheKey))
          .thenAnswer((_) => pictureLisMock);

      final response = await sut.getPictures();

      expect(response.length, 2);
      expect(response.last["title"], "NGC 7635: The Bubble Nebula Expanding");

      verify(
        () => localStorageClient.getList(AppConstants.pictureListCacheKey),
      );
    });

    test("Should throw an AppError invalidData", () async {
      when(() => localStorageClient.getList(AppConstants.pictureListCacheKey))
          .thenAnswer((_) => []);

      try {
        await sut.getPictures();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.datasource);
      }

      verify(
          () => localStorageClient.getList(AppConstants.pictureListCacheKey));
    });

    test("Should throw an AppError localStorage", () async {
      when(() => localStorageClient.getList(AppConstants.pictureListCacheKey))
          .thenThrow(Exception());

      try {
        await sut.getPictures();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.datasource);
      }

      verify(
          () => localStorageClient.getList(AppConstants.pictureListCacheKey));
    });
  });
}
