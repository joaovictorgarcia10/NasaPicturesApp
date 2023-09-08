import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/features/core/error/app_error.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';

import '../../mock/picture_list_mock.dart';

class PicturesRemoteDatasourceMock extends Mock implements PicturesDatasource {}

class PicturesLocalDatasourceMock extends Mock implements PicturesDatasource {}

void main() {
  late PicturesRepository sut;
  late PicturesDatasource remoteDatasource;
  late PicturesDatasource localDatasource;

  setUp(() {
    remoteDatasource = PicturesRemoteDatasourceMock();
    localDatasource = PicturesLocalDatasourceMock();

    sut = PicturesRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
    );
  });

  group("PicturesRepository Test", () {
    test(
        "Should get a List<Map<String, dynamic>> from the remoteDatasource and rerturn a List<Picture>",
        () async {
      when(() => remoteDatasource.getPictures())
          .thenAnswer((_) => Future.value(pictureLisMock));

      final response = await sut.getPictures(isOnline: true);

      expect(response.length, 2);
      expect(response, isA<List<Picture>>());
    });

    test("Should throw an AppError invalidData calling the remoteDatasource",
        () async {
      when(() => remoteDatasource.getPictures())
          .thenThrow(AppError(type: AppErrorType.invalidData));

      try {
        await sut.getPictures(isOnline: true);
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.invalidData);
      }
    });

    test(
        "Should get a List<Map<String, dynamic>> from the localDatasource and rerturn a List<Picture>",
        () async {
      when(() => localDatasource.getPictures())
          .thenAnswer((_) => Future.value(pictureLisMock));

      final response = await sut.getPictures(isOnline: false);

      expect(response.length, 2);
      expect(response, isA<List<Picture>>());
    });

    test("Should throw an AppError invalidData calling the localDatasource",
        () async {
      when(() => localDatasource.getPictures())
          .thenThrow(AppError(type: AppErrorType.invalidData));

      try {
        await sut.getPictures(isOnline: false);
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.invalidData);
      }
    });
  });
}
