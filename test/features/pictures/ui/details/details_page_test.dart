import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nasa_pictures_app/modules/pictures/data/dtos/picture_dto.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/home_state.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/details/details_page.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_page.dart';
import 'package:nasa_pictures_app/modules/pictures/ui/home/home_presenter.dart';

import '../../mock/picture_list_mock.dart';

class HomePresenterMock extends Mock implements HomePresenter {}

class NavigatorObserverMock extends Mock implements NavigatorObserver {}

void main() {
  late DetailsPage sut;
  late HomePage homePage;
  late HomePresenter presenter;
  late NavigatorObserver navigatorObserver;

  setUp(() {
    sut = const DetailsPage();
    presenter = HomePresenterMock();
    homePage = HomePage(presenter: presenter);
    navigatorObserver = NavigatorObserverMock();

    when(() => presenter.state).thenReturn(ValueNotifier(HomeStateLoading()));
    when(() => presenter.shouldPaginate).thenReturn(ValueNotifier(true));
    when(() => presenter.refreshPictures()).thenAnswer((_) async {});
    when(() => presenter.paginatePictures()).thenAnswer((_) async {});
    when(() => presenter.search("")).thenAnswer((_) async {});
  });

  group("DetailsPage Tests", () {
    testWidgets(
      "Should naviagte to details page and render with the expected values",
      (widgetTester) async {
        when(() => presenter.getPictures()).thenAnswer((_) async {
          final pictures = pictureLisMock
              .map((e) => PictureDto.fromMap(e).toEntity())
              .toList();

          presenter.state.value = HomeStateSuccess(pictures: pictures);
        });

        await widgetTester.pumpWidget(
          MaterialApp(
            home: homePage,
            routes: {"/details": (context) => sut},
            navigatorObservers: [navigatorObserver],
          ),
        );

        final findButton = find.byKey(const Key("icon-button-key-0"));
        expect(findButton, findsOneWidget);
        await widgetTester.pump();

        await widgetTester.tap(findButton);
        await widgetTester.pumpAndSettle();

        expect(find.byType(DetailsPage), findsOneWidget);
        expect(find.text("Details"), findsOneWidget);

        expect(find.text("M13: The Great Globular Cluster in Hercules"),
            findsOneWidget);
        expect(find.text("18/05/2007"), findsOneWidget);
      },
    );
  });
}
