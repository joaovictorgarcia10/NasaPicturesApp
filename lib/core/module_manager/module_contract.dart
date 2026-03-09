import 'package:nasa_pictures_app/core/module_manager/module_utils.dart';
import 'package:nasa_pictures_app/core/adapters/dependency_injector/dependency_injector.dart';

abstract class ModuleContract {
  String get moduleName;

  DependencyInjector get injector;

  void Function() get registerDependencies;

  Map<String, WidgetBuilderArgs> get routes;
}
