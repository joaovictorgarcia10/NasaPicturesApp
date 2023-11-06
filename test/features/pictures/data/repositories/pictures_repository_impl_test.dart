import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/infrastructure/network_connection/network_connection_client.dart';
import 'package:nasa_pictures_app/features/pictures/data/datasources/pictures_datasource.dart';
import 'package:nasa_pictures_app/features/pictures/data/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';

import '../../mock/picture_list_mock.dart';

class PicturesRemoteDatasourceMock extends Mock implements PicturesDatasource {}

class PicturesLocalDatasourceMock extends Mock implements PicturesDatasource {}

class NetworkConnectionClientMock extends Mock
    implements NetworkConnectionClient {}

void main() {
  late PicturesRepository sut;
  late PicturesDatasource remoteDatasource;
  late PicturesDatasource localDatasource;
  late NetworkConnectionClient networkConnectionClient;

  setUp(() {
    remoteDatasource = PicturesRemoteDatasourceMock();
    localDatasource = PicturesLocalDatasourceMock();
    networkConnectionClient = NetworkConnectionClientMock();

    sut = PicturesRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
      networkConnectionClient: networkConnectionClient,
    );
  });

  group("PicturesRepository Test", () {
    test(
        "Should get a List<Map<String, dynamic>> from the remoteDatasource and rerturn a List<Picture>",
        () async {
      when(() => networkConnectionClient.hasConnection())
          .thenAnswer((_) => Future.value(true));

      when(() => remoteDatasource.getPictures())
          .thenAnswer((_) => Future.value(pictureLisMock));

      final response = await sut.getPictures();

      expect(response.length, 2);
      expect(response, isA<List<Picture>>());
    });

    test("Should throw an AppError repository calling the remoteDatasource",
        () async {
      when(() => remoteDatasource.getPictures())
          .thenThrow(AppError(type: AppErrorType.repository));

      try {
        await sut.getPictures();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.repository);
      }
    });

    test(
        "Should get a List<Map<String, dynamic>> from the localDatasource and rerturn a List<Picture>",
        () async {
      when(() => networkConnectionClient.hasConnection())
          .thenAnswer((_) => Future.value(false));

      when(() => localDatasource.getPictures())
          .thenAnswer((_) => Future.value(pictureLisMock));

      final response = await sut.getPictures();

      expect(response.length, 2);
      expect(response, isA<List<Picture>>());
    });

    test("Should throw an AppError repository calling the localDatasource",
        () async {
      when(() => localDatasource.getPictures())
          .thenThrow(AppError(type: AppErrorType.repository));

      try {
        await sut.getPictures();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.repository);
      }
    });
  });
}
