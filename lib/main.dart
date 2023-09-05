import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/app/app_dependencies.dart';
import 'package:nasa_pictures_app/app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies().registerAppDependencies();
  runApp(const AppWidget());
}
