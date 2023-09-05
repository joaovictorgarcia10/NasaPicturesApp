import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/features/pictures/ui/pages/details/details_page.dart';
import 'package:nasa_pictures_app/features/pictures/ui/pages/home/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nasa Pictures App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/": (context) => const HomePage(),
        "/details": (context) => const DetailsPage(),
      },
    );
  }
}
