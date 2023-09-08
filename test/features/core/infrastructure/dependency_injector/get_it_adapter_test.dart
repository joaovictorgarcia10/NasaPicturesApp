import 'package:flutter_test/flutter_test.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/dependency_injector/adapter/get_it_adapter.dart';
import 'package:nasa_pictures_app/features/core/infrastructure/dependency_injector/dependency_injector.dart';

void main() {
  late DependencyInjector sut;

  setUp(() async {
    sut = GetItAdapter();
    await sut.reset();
  });

  group("GetItAdapter Tests", () {
    test("Should return the correct value of a registered Lazy Singleton ", () {
      sut.registerLazySingleton<String>(
        instance: "hello world lazy singleton",
        instanceName: "myLazySingleton",
      );

      final result = sut.get<String>(instanceName: "myLazySingleton");

      expect(result, "hello world lazy singleton");
      expect(sut.isRegistered<String>(instanceName: "myLazySingleton"), true);
      expect(
        sut.isRegistered<String>(instanceName: "notRegisteredInstance"),
        false,
      );
    });

    test('Should throw an error trying to access a not registered type', () {
      expect(
        () => sut.get<int>(),
        throwsA(const TypeMatcher<StateError>()),
      );
    });

    test('Should throw an error when call get after Unregister', () async {
      sut.registerLazySingleton<String>(
          instance: "hello world", instanceName: "mySingleton");

      final result = sut.get<String>(instanceName: "mySingleton");
      expect(result, isInstanceOf<String>());

      await sut.unregister<String>(instanceName: "mySingleton");

      expect(
        () => sut.get<String>(instanceName: "mySingleton"),
        throwsA(const TypeMatcher<StateError>()),
      );
    });

    test("Should throw an error when call get after Reset", () async {
      sut.registerLazySingleton<String>(
          instance: "hello world", instanceName: "mySingleton");

      await sut.reset();

      expect(
        () => sut.get<String>(instanceName: "mySingleton"),
        throwsA(const TypeMatcher<StateError>()),
      );
    });
  });
}