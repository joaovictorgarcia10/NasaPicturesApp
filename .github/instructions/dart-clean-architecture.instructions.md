---
name: Dart Clean Architecture Rules
description: Architectural rules for all Dart source files in lib/
applyTo: lib/**/*.dart
---

# Clean Architecture Rules for Dart Source Files

## Layer Boundaries (strictly enforced)

- **`domain/entities/`** — Pure Dart classes only. No `package:` imports. No `flutter/` imports.
- **`domain/repositories/`** — Abstract interfaces only. Return domain entities, never Maps or DTOs.
- **`domain/usecases/`** — Depend only on repository interfaces. Return domain entities. No data layer imports.
- **`data/dtos/`** — DTOs map raw API/storage `Map<String, dynamic>` to domain entities via `fromMap()` and `toEntity()`.
- **`data/datasources/`** — Implement the abstract `<Feature>Datasource` interface. Throw `AppError` on failure.
- **`data/repositories/`** — Implement domain repository interfaces. Use DTOs to map data. Route between remote and local datasource via `NetworkConnectionController`.
- **`presentation/`** — Abstract `Presenter` interface with `ValueNotifier` getters + concrete `PresenterImpl`. No UI imports.
- **`ui/`** — Widgets only. Depend only on the abstract `Presenter` interface. Never access `PresenterImpl` directly.
- **`core/infrastructure/<category>/adapter/`** — The ONLY files allowed to import third-party packages (Dio, SharedPreferences, GetIt).

## Error Handling — Mandatory Pattern

Every layer must follow this exact pattern:

```dart
try {
  // ... work
} on AppError catch (_) {
  rethrow; // always rethrow AppError as-is FIRST
} catch (e) {
  throw AppError(type: AppErrorType.<layer>, exception: e);
}
```

- Use `AppErrorType.datasource` in datasource classes.
- Use `AppErrorType.repository` in repository classes.
- Use `AppErrorType.localStorage` in `SharedPreferencesAdapter`.
- Use `AppErrorType.httpRequest` / `httpResponse` in `DioAdapter`.
- Use `AppErrorType.dependencyInjector` in `GetItAdapter`.

## Dependency Injection

- All new classes that need DI must be registered in `AppDependencies.registerAppDependencies()` using `injector.registerLazySingleton<Interface>(instance: ConcreteImpl(...))`.
- Registration order: infrastructure adapters → datasources → repositories → usecases → presenters.
- Never call `GetIt.instance` or `GetIt.I` directly — always use `GetItAdapter`.

## State Management

- State classes must form a sealed hierarchy:
  ```dart
  abstract class <Screen>State {}
  class <Screen>StateLoading extends <Screen>State {}
  class <Screen>StateSuccess extends <Screen>State { final List<Entity> items; }
  class <Screen>StateError extends <Screen>State { final String message; }
  ```
- Presenters expose state via `ValueNotifier<State>`, never via `Stream` or `ChangeNotifier`.
- `ValueNotifier`s must be disposed in the widget's `dispose()`.

## Code Style

- Never use `print()` — use `debugPrint()` or `log()` from `dart:developer`.
- All public classes, methods, and properties must have `///` doc comments.
- Prefer `const` constructors everywhere possible.
- File names: `snake_case.dart`. Class names: `PascalCase`.
- Import order: `dart:` → `package:` → relative (each group separated by a blank line).
- Never hardcode API keys, base URLs, or environment-specific values — use `AppEnvironment`.
