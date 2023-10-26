import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/core/infrastructure/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/features/pictures/ui/details/details_page.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/home_page.dart';
import 'package:nasa_pictures_app/features/pictures/ui/home/home_presenter.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final injector = GetItAdapter();

    return MaterialApp(
      title: 'Nasa Pictures App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => HomePage(presenter: injector.get<HomePresenter>()),
        "/details": (context) => const DetailsPage(),
      },
    );
  }
}
