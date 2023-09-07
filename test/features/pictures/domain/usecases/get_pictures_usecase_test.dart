import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/features/core/error/app_error.dart';
import 'package:nasa_pictures_app/features/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/features/pictures/domain/repositories/pictures_repository.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/check_internet_connection_usecase.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/get_pictures_usecase.dart';

class PicturesRepositoryMock extends Mock implements PicturesRepository {}

class CheckInternetConnectionUsecaseMock extends Mock
    implements CheckInternetConnectionUsecase {}

void main() {
  late GetPicturesUsecase sut;
  late CheckInternetConnectionUsecase checkInternetConnection;
  late PicturesRepository repository;
  late List<Picture> mock;

  setUp(() {
    repository = PicturesRepositoryMock();
    checkInternetConnection = CheckInternetConnectionUsecaseMock();
    sut = GetPicturesUsecase(
      repository: repository,
      checkInternetConnection: checkInternetConnection,
    );

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

    when(() => checkInternetConnection()).thenAnswer((_) => Future.value(true));
  });

  group("GetPicturesUsecase Tests", () {
    test("Should get a list of Pictures with success", () async {
      when(() => repository.getPictures(isOnline: true))
          .thenAnswer((_) async => mock);

      final response = await sut();

      expect(response.length, 1);
      expect(response.first.title, "title");
      verify(() => checkInternetConnection());
      verify(() => repository.getPictures(isOnline: true));
    });

    test("Should throw an AppError invalidData", () async {
      when(() => repository.getPictures(isOnline: true))
          .thenThrow(AppError(type: AppErrorType.invalidData));

      try {
        await sut();
      } on AppError catch (e) {
        expect(e, isA<AppError>());
        expect(e.type, AppErrorType.invalidData);
      }

      verify(() => checkInternetConnection());
      verify(() => repository.getPictures(isOnline: true));
    });
  });
}
