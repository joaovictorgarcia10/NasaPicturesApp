import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/widgets/picture_list_tile_widget.dart';

void main() {
  late PictureListTileWidget sut;

  setUp(() {
    sut = PictureListTileWidget(
      url: "url",
      title: "title",
      date: "date",
      onPressed: () {},
    );
  });
  testWidgets('Should render PictureListTileWidget with the expected values',
      (widgetTester) async {
    await widgetTester.pumpWidget(MaterialApp(home: sut));
    expect(find.byType(Card), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsOneWidget);
    expect(find.text("title"), findsOneWidget);
    expect(find.text("date"), findsOneWidget);
  });
}
