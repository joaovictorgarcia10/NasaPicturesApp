import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/modules/pictures/presentation/home/widgets/picture_app_bar_widget.dart';

void main() {
  late PictureAppBarWidget sut;

  setUp(() {
    sut = PictureAppBarWidget(
      textController: TextEditingController(),
      onSearchChanged: (value) {},
      onFilterByDate: () {},
      onFilterByDateRange: () {},
    );
  });

  testWidgets('Should render PictureAppBarWidget with the expected values', (
    widgetTester,
  ) async {
    await widgetTester.pumpWidget(MaterialApp(home: sut));
    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('Search by title...'), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsOneWidget);
  });
}
