import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/core/module_manager/module_contract.dart';
import 'package:nasa_pictures_app/core/module_manager/module_manager.dart';
import 'package:nasa_pictures_app/core/module_manager/module_utils.dart';
import 'package:nasa_pictures_app/modules/pictures/pictures_module.dart';

class AppWidget extends StatelessWidget with ModuleManager {
  AppWidget({super.key}) {
    super.registerRoutes();
    super.registerDependencies();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nasa Pictures App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: super.generateRoute,
    );
  }

  @override
  Map<String, WidgetBuilderArgs> get globalRoutes => {};

  @override
  List<ModuleContract> get modules => [PicturesModule()];
}
