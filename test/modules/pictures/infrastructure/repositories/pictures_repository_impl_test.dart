import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/controllers/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_local_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/data/datasources/pictures_remote_datasource.dart';
import 'package:nasa_pictures_app/modules/pictures/infrastructure/repositories/pictures_repository_impl.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';

import '../../mock/picture_list_mock.dart';

class PicturesRemoteDatasourceMock extends Mock
    implements PicturesRemoteDatasource {}

class PicturesLocalDatasourceMock extends Mock
    implements PicturesLocalDatasource {}

class NetworkConnectionControllerMock extends Mock
    implements NetworkConnectionController {}

void main() {
  late PicturesRepository sut;
  late PicturesRemoteDatasource remoteDatasource;
  late PicturesLocalDatasource localDatasource;
  late NetworkConnectionController networkConnectionController;

  setUp(() {
    remoteDatasource = PicturesRemoteDatasourceMock();
    localDatasource = PicturesLocalDatasourceMock();
    networkConnectionController = NetworkConnectionControllerMock();

    sut = PicturesRepositoryImpl(
      remoteDatasource: remoteDatasource,
      localDatasource: localDatasource,
      networkConnectionController: networkConnectionController,
    );
  });

  group("PicturesRepository Test", () {
    test(
      "Should get a List<Map<String, dynamic>> from the remoteDatasource and rerturn a List<Picture>",
      () async {
        when(
          () => networkConnectionController.hasConnection(),
        ).thenAnswer((_) => Future.value(true));

        when(
          () => remoteDatasource.getPictures(
            date: any(named: 'date'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) => Future.value(pictureLisMock));

        when(
          () => localDatasource.savePictures(pictures: any(named: 'pictures')),
        ).thenAnswer((_) => Future.value());

        final response = await sut.getPictures();

        expect(response.length, 2);
        expect(response, isA<List<Picture>>());
      },
    );

    test(
      "Should pass date param to remoteDatasource and return a List<Picture>",
      () async {
        when(
          () => networkConnectionController.hasConnection(),
        ).thenAnswer((_) => Future.value(true));

        when(
          () => remoteDatasource.getPictures(
            date: any(named: 'date'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) => Future.value(pictureLisMock));

        when(
          () => localDatasource.savePictures(pictures: any(named: 'pictures')),
        ).thenAnswer((_) => Future.value());

        final response = await sut.getPictures(date: "2026-03-03");

        expect(response.length, 2);
        expect(response, isA<List<Picture>>());
      },
    );

    test(
      "Should pass date range params to remoteDatasource and return a List<Picture>",
      () async {
        when(
          () => networkConnectionController.hasConnection(),
        ).thenAnswer((_) => Future.value(true));

        when(
          () => remoteDatasource.getPictures(
            date: any(named: 'date'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) => Future.value(pictureLisMock));

        when(
          () => localDatasource.savePictures(pictures: any(named: 'pictures')),
        ).thenAnswer((_) => Future.value());

        final response = await sut.getPictures(
          startDate: "2024-01-01",
          endDate: "2024-01-31",
        );

        expect(response.length, 2);
        expect(response, isA<List<Picture>>());
      },
    );

    test("Should propagate Exception from the remoteDatasource", () async {
      when(
        () => networkConnectionController.hasConnection(),
      ).thenAnswer((_) => Future.value(true));

      when(() => remoteDatasource.getPictures()).thenThrow(Exception());

      await expectLater(() => sut.getPictures(), throwsA(isA<Exception>()));
    });

    test(
      "Should get a List<Map<String, dynamic>> from the localDatasource and rerturn a List<Picture>",
      () async {
        when(
          () => networkConnectionController.hasConnection(),
        ).thenAnswer((_) => Future.value(false));

        when(
          () => localDatasource.getPictures(
            date: any(named: 'date'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) => Future.value(pictureLisMock));

        final response = await sut.getPictures();

        expect(response.length, 2);
        expect(response, isA<List<Picture>>());
      },
    );

    test("Should propagate Exception from the localDatasource", () async {
      when(
        () => networkConnectionController.hasConnection(),
      ).thenAnswer((_) => Future.value(false));

      when(() => localDatasource.getPictures()).thenThrow(Exception());

      await expectLater(() => sut.getPictures(), throwsA(isA<Exception>()));
    });
  });
}
