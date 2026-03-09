import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nasa_pictures_app/core/module_manager/module_contract.dart';
import 'package:nasa_pictures_app/core/module_manager/module_utils.dart';

mixin ModuleManager {
  Map<String, WidgetBuilderArgs> get globalRoutes;
  List<ModuleContract> get modules;

  final Map<String, WidgetBuilderArgs> _routes = {};

  void registerRoutes() {
    if (globalRoutes.isNotEmpty) _routes.addAll(globalRoutes);

    if (modules.isNotEmpty) {
      for (ModuleContract module in modules) {
        _routes.addAll(module.routes);
      }
    }
  }

  void registerDependencies() {
    if (modules.isNotEmpty) {
      for (ModuleContract module in modules) {
        module.registerDependencies();

        if (kDebugMode) {
          print("${module.moduleName} Resgistered");
        }
      }
    }
  }

  Route<dynamic>? Function(RouteSettings settings) get generateRoute => (
    RouteSettings settings,
  ) {
    var routerName = settings.name;
    var routerArgs = settings.arguments;
    var navigateTo = _routes[routerName];

    if (navigateTo == null) {
      return null;
    } else {
      return MaterialPageRoute(
        builder: (context) => navigateTo.call(context, routerArgs),
      );
    }
  };
}
