import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/modules/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_state.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_page.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_presenter.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/widgets/picture_list_tile_widget.dart';

import '../../mock/picture_list_mock.dart';

class HomePresenterMock extends Mock implements HomePresenter {}

void main() {
  late HomePage sut;
  late HomePresenter presenter;

  setUp(() {
    presenter = HomePresenterMock();
    sut = HomePage(presenter: presenter);

    when(() => presenter.state).thenReturn(ValueNotifier(HomeStateLoading()));
    when(() => presenter.shouldPaginate).thenReturn(ValueNotifier(true));
    when(() => presenter.refreshPictures()).thenAnswer((_) async {});
    when(() => presenter.paginatePictures()).thenAnswer((_) async {});
    when(() => presenter.search("")).thenAnswer((_) async {});
  });

  group("HomePage Tests", () {
    testWidgets("Should render the HomePage with HomeStateLoading",
        (widgetTester) async {
      when(() => presenter.getPictures()).thenAnswer((_) async {});

      await widgetTester.pumpWidget(MaterialApp(home: sut));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Should render the HomePage with HomeStateSuccess",
        (widgetTester) async {
      when(() => presenter.getPictures()).thenAnswer((_) async {
        final pictures = pictureLisMock
            .map((e) => PictureDto.fromMap(e).toEntity())
            .toList();

        presenter.state.value = HomeStateSuccess(pictures: pictures);
      });

      await widgetTester.pumpWidget(MaterialApp(home: sut));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(PictureListTileWidget), findsNWidgets(2));
    });

    testWidgets("Should render the HomePage with HomeStateError",
        (widgetTester) async {
      when(() => presenter.getPictures()).thenAnswer((_) async {
        presenter.state.value =
            HomeStateError(message: "Something went wrong.");
      });

      await widgetTester.pumpWidget(MaterialApp(home: sut));
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text("Something went wrong."), findsOneWidget);
    });
  });
}
