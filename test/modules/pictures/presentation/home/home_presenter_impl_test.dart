import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/utils/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/modules/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/entities/picture.dart';
import 'package:nasa_pictures_app/modules/pictures/domain/usecases/get_pictures_usecase.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_presenter_impl.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_state.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_presenter.dart';

import '../../mock/picture_list_mock.dart';

class GetPicturesUsecaseMock extends Mock implements GetPicturesUsecase {}

class NetworkConnectionControllerMock extends Mock
    implements NetworkConnectionController {}

void main() {
  late HomePresenter sut;
  late GetPicturesUsecase getPicturesUsecase;
  late NetworkConnectionController networkConnectionController;
  late List<Picture> pictures;
  late List<HomeState> states;

  void listenStates() {
    states = [];
    sut.state.addListener(() {
      if (!states.contains(sut.state.value)) {
        states.add(sut.state.value);
      }
    });
  }

  void cleanStates() {
    states = [];
  }

  setUp(() {
    getPicturesUsecase = GetPicturesUsecaseMock();
    networkConnectionController = NetworkConnectionControllerMock();
    sut = HomePresenterImpl(
      getPicturesUsecase: getPicturesUsecase,
      networkConnectionController: networkConnectionController,
    );

    pictures =
        pictureLisMock.map((e) => PictureDto.fromMap(e).toEntity()).toList();

    listenStates();
  });

  group("HomePresenter Tests", () {
    test("Should getPictures and set state to HomeStateSuccess", () async {
      when(() => getPicturesUsecase())
          .thenAnswer((_) => Future.value(pictures));

      await sut.getPictures();
      expect(states[0], isA<HomeStateLoading>());
      expect(states[1], isA<HomeStateSuccess>());
      expect(sut.state.value, isA<HomeStateSuccess>());
      cleanStates();
    });

    test("Should getPictures and set state to HomeStateError", () async {
      when(() => getPicturesUsecase())
          .thenThrow(AppError(type: AppErrorType.invalidData));

      await sut.getPictures();
      expect(states[0], isA<HomeStateLoading>());
      expect(states[1], isA<HomeStateError>());
      expect(sut.state.value, isA<HomeStateError>());
      cleanStates();
    });

    test("Should refreshPictures and set state to HomeStateSuccess", () async {
      when(() => getPicturesUsecase())
          .thenAnswer((_) => Future.value(pictures));

      await sut.refreshPictures();
      expect(states[0], isA<HomeStateLoading>());
      expect(states[1], isA<HomeStateSuccess>());
      expect(sut.state.value, isA<HomeStateSuccess>());
      expect(sut.shouldPaginate.value, true);
      cleanStates();
    });

    test("Should refreshPictures and set state to HomeStateError", () async {
      when(() => getPicturesUsecase())
          .thenThrow(AppError(type: AppErrorType.invalidData));

      await sut.refreshPictures();
      expect(states[0], isA<HomeStateLoading>());
      expect(states[1], isA<HomeStateError>());
      expect(sut.state.value, isA<HomeStateError>());
      expect(sut.shouldPaginate.value, true);
      cleanStates();
    });

    test("Should paginatePictures and set state to HomeStateSuccess", () async {
      when(() => networkConnectionController.hasConnection())
          .thenAnswer((_) => Future.value(true));

      when(() => getPicturesUsecase())
          .thenAnswer((_) => Future.value(pictures));

      await sut.paginatePictures();
      expect(sut.state.value, isA<HomeStateSuccess>());
      cleanStates();
    });

    test("Should paginatePictures and set shouldPaginate to false", () async {
      when(() => networkConnectionController.hasConnection())
          .thenAnswer((_) => Future.value(false));

      when(() => getPicturesUsecase())
          .thenThrow(AppError(type: AppErrorType.invalidData));

      await sut.paginatePictures();
      expect(sut.shouldPaginate.value, false);
      cleanStates();
    });

    test("Should search and set state to HomeStateSuccess", () async {
      when(() => getPicturesUsecase())
          .thenAnswer((_) => Future.value(pictures));

      await sut.getPictures();
      await sut.search("18/05/2007");

      expect(states[0], isA<HomeStateLoading>());
      expect(states[1], isA<HomeStateSuccess>());

      expect(states[2], isA<HomeStateSuccess>());
      expect(states[3], isA<HomeStateSuccess>());
      expect(sut.state.value, isA<HomeStateSuccess>());
      cleanStates();
    });

    test("Should search and set state to HomeStateError", () async {
      when(() => getPicturesUsecase())
          .thenAnswer((_) => Future.value(pictures));

      await sut.getPictures();
      await sut.search("03/10/2000");

      expect(states[0], isA<HomeStateLoading>());
      expect(states[1], isA<HomeStateSuccess>());

      expect(states[2], isA<HomeStateSuccess>());
      expect(states[3], isA<HomeStateError>());
      expect(sut.state.value, isA<HomeStateError>());
      cleanStates();
    });
  });
}
