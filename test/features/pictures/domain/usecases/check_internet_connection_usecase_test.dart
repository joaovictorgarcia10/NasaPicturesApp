import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/features/pictures/domain/usecases/check_internet_connection_usecase.dart';

void main() {
  late CheckInternetConnectionUsecase sut;

  setUp(() {
    sut = CheckInternetConnectionUsecase();
  });

  group("GetPicturesUsecase Tests", () {
    test("Should check the internet connection with success", () async {
      final response = await sut();
      expect(response, true);
    });
  });
}
