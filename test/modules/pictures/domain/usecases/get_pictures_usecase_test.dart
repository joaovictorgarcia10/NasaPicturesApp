import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/error/app_error.dart';
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
      )
    ];
  });

  group("GetPicturesUsecase Tests", () {
    test("Should get a list of Pictures with success", () async {
      when(() => repository.getPictures()).thenAnswer((_) async => mock);

      final response = await sut();

      expect(response.length, 1);
      expect(response.first.title, "title");
      verify(() => repository.getPictures());
    });

    test("Should throw an AppError invalidData", () async {
      when(() => repository.getPictures())
          .thenThrow(AppError(type: AppErrorType.invalidData));

      try {
        await sut();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.invalidData);
      }

      verify(() => repository.getPictures());
    });
  });
}
