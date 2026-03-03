# NASA Pictures App — Copilot Instructions

## Project Context

This is a **Flutter/Dart** application using **Clean Architecture** with four strict layers:
`data` → `domain` → `presentation` → `ui`

The canonical feature module to reference for any code generation is `lib/modules/pictures/`.

---

## Architecture Conventions

- **Clean Architecture** — domain layer has zero framework/package dependencies; entities are pure Dart classes.
- **Adapter Pattern** — every third-party library (Dio, SharedPreferences, GetIt) lives behind an abstract interface in `core/infrastructure/`. Never import `dio`, `shared_preferences`, or `get_it` directly outside their adapter files.
- **State Management** — `ValueNotifier<T>` only. No BLoC, Riverpod, or Provider. State classes are abstract sealed hierarchies (e.g., `HomeStateLoading`, `HomeStateSuccess`, `HomeStateError`).
- **Presenter Pattern** — each feature's presentation layer has an abstract `Presenter` interface (with `ValueNotifier` getters) and a concrete `PresenterImpl`. The UI only depends on the abstract interface.
- **Dependency Injection** — `GetItAdapter` (implements `DependencyInjector`). All registrations live in `AppDependencies.registerAppDependencies()`. Never call `GetIt.instance` directly.

---

## Error Handling

- `AppError` (in `core/error/app_error.dart`) is the **only** exception type that propagates between layers.
- Every layer catches raw exceptions and wraps them: `throw AppError(type: AppErrorType.xxx, exception: e)`.
- `AppErrorType` enum values: `dependencyInjector`, `httpRequest`, `httpResponse`, `localStorage`, `invalidData`, `datasource`, `repository`.
- Always rethrow `AppError` as-is with `on AppError catch (_) { rethrow; }` before the generic catch.

---

## Naming Conventions

| Artifact | Convention | Example |
|---|---|---|
| Feature module folder | `snake_case` | `pictures`, `settings` |
| Abstract datasource | `<Feature>Datasource` | `PicturesDatasource` |
| Remote datasource | `<Feature>RemoteDatasource` | `PicturesRemoteDatasource` |
| Local datasource | `<Feature>LocalDatasource` | `PicturesLocalDatasource` |
| Repository interface | `<Feature>Repository` | `PicturesRepository` |
| Repository implementation | `<Feature>RepositoryImpl` | `PicturesRepositoryImpl` |
| Use case | `<Verb><Feature>Usecase` | `GetPicturesUsecase` |
| DTO | `<Entity>Dto` | `PictureDto` |
| Presenter interface | `<Screen>Presenter` | `HomePresenter` |
| Presenter implementation | `<Screen>PresenterImpl` | `HomePresenterImpl` |
| State classes | `<Screen>State`, `<Screen>StateLoading`, `<Screen>StateSuccess`, `<Screen>StateError` | `HomeState*` |
| Test files | Mirror source path + `_test.dart` suffix | `get_pictures_usecase_test.dart` |

---

## Code Style Rules

- Never use `print()` — use `debugPrint()` or `log()` from `dart:developer`.
- All public classes, methods, and properties must have Dart doc comments (`///`).
- Prefer `const` constructors everywhere possible.
- File names: `snake_case.dart`. Class names: `PascalCase`.
- Imports order: dart: → package: → relative (separated by blank lines).
- Do not add packages to `pubspec.yaml` without confirming they belong in `dependencies` vs `dev_dependencies`.

---

## Environment Variables

Compile-time only via `--dart-define`. Accessed through `AppEnvironment`:

```dart
// lib/core/environment/app_environment.dart
class AppEnvironment {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const apiKey = String.fromEnvironment('API_KEY');
}
```

Never hardcode API keys or URLs. Never create `.env` files.

---

## Testing Rules

- Use `mocktail` for all mocking. Never use `mockito`.
- Test file location must mirror source: `lib/modules/pictures/domain/usecases/get_pictures_usecase.dart` → `test/modules/pictures/domain/usecases/get_pictures_usecase_test.dart`.
- Shared test fixtures live in `test/modules/pictures/mock/picture_list_mock.dart` — reuse them.
- Every new `UseCase`, `Repository`, and `Presenter` must have a corresponding unit test file.
