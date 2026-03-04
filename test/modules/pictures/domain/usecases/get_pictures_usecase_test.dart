import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/usecases/get_pictures_usecase.dart';

class PicturesRepositoryMock extends Mock implements PicturesRepository {}

void main() {
  late GetPicturesUsecase sut;
  late PicturesRepository repository;
  late List<Picture> mock;

  setUp(() {
    repository = PicturesRepositoryMock();
    sut = GetPicturesUsecase(repository: repository);

    mock = [
      Picture(
        copyright: "copyright",
        date: "date",
        explanation: "explanation",
        hdurl: "hdurl",
        mediaType: "mediaType",
        serviceVersion: "serviceVersion",
        title: "title",
        url: "url",
      ),
    ];
  });

  group("GetPicturesUsecase Tests", () {
    test("Should get a list of Pictures with success", () async {
      when(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => mock);

      final response = await sut();

      expect(response.length, 1);
      expect(response.first.title, "title");
      verify(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      );
    });

    test("Should get a list of Pictures with a specific date", () async {
      when(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => mock);

      final response = await sut(date: "2026-03-03");

      expect(response.length, 1);
      verify(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      );
    });

    test("Should get a list of Pictures with a date range", () async {
      when(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) async => mock);

      final response = await sut(
        startDate: "2024-01-01",
        endDate: "2024-01-31",
      );

      expect(response.length, 1);
      verify(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      );
    });

    test("Should propagate Exception from repository", () async {
      when(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenThrow(Exception());

      await expectLater(() => sut(), throwsA(isA<Exception>()));

      verify(
        () => repository.getPictures(
          date: any(named: 'date'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      );
    });
  });
}
