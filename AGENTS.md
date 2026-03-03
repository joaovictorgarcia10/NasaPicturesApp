# Agent Instructions — nasa_pictures_app

## Project Overview

Flutter mobile application (iOS & Android) that fetches and displays NASA's **Astronomy Picture of the Day (APOD)** from the [NASA API](https://api.nasa.gov/). Users can browse a paginated list of pictures, search by title or date, pull to refresh, and view full details of each entry.

- **Language:** Dart 3 / Flutter
- **Architecture:** Clean Architecture (Data → Domain → Presentation → UI)
- **State Management:** `ValueNotifier` (no external state management package)
- **DI:** `GetIt` wrapped behind the `GetItAdapter` / `DependencyInjector` abstraction
- **HTTP:** `Dio` wrapped behind `DioAdapter` / `HttpClient` abstraction
- **Local Cache:** `SharedPreferences` wrapped behind `SharedPreferencesAdapter` / `LocalStorageClient` abstraction
- **Testing:** `flutter_test` + `mocktail`

---

## Build & Run Commands

Always provide environment variables at compile time via `--dart-define`. There is no `.env` file.

```bash
# Install dependencies
flutter pub get

# Run on a connected device/simulator
flutter run \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=<YOUR_NASA_API_KEY>

# Build release APK
flutter build apk \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=<YOUR_NASA_API_KEY>

# Build iOS
flutter build ios \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=<YOUR_NASA_API_KEY>
```

> ⚠️ If `API_BASE_URL` or `API_KEY` are not provided, `AppEnvironment.apiBaseUrl` and `AppEnvironment.apiKey` will be empty strings — API calls will silently fail.

---

## Test & Quality Commands

```bash
# Run all tests
flutter test

# Run tests with coverage (generates coverage/lcov.info)
flutter test --coverage

# Generate HTML coverage report (requires lcov: brew install lcov)
./flutter_test_coverage.sh

# Open coverage report
open coverage/html/index.html

# Static analysis (must exit 0 before merging)
flutter analyze

# Format all Dart files
dart format lib/ test/
```

> **Rule:** `flutter test` and `flutter analyze` must both exit 0 before any commit.

---

## Architecture — Folder Structure

```
lib/
├── app/
│   ├── app_dependencies.dart   ← DI registration (all registerLazySingleton calls live here)
│   └── app_widget.dart         ← Root MaterialApp with named routes
├── core/
│   ├── constants/              ← AppConstants (cache key, pagination limit, etc.)
│   ├── environment/            ← AppEnvironment (compile-time --dart-define values)
│   ├── error/                  ← AppError + AppErrorType (the ONLY error mechanism)
│   ├── infrastructure/
│   │   ├── dependency_injector/
│   │   │   ├── dependency_injector.dart        ← abstract interface
│   │   │   └── adapter/get_it_adapter.dart     ← concrete adapter
│   │   ├── http/
│   │   │   ├── http_client.dart                ← abstract interface
│   │   │   └── adapter/dio_adapter.dart        ← concrete adapter
│   │   └── local_storage/
│   │       ├── local_storage_client.dart       ← abstract interface
│   │       └── adapter/shared_preferences_adapter.dart ← concrete adapter
│   └── utils/
│       └── network_connection/
│           └── network_connection_controller.dart
└── modules/
    └── pictures/               ← canonical feature module (use as template)
        ├── data/
        │   ├── datasources/    ← PicturesDatasource (abstract), Remote + Local impls
        │   ├── dtos/           ← PictureDto (fromMap → toEntity)
        │   ├── helpers/        ← date_formater_extension.dart
        │   └── repositories/   ← PicturesRepositoryImpl
        ├── domain/
        │   ├── entities/       ← Picture (pure Dart, no framework deps)
        │   ├── repositories/   ← PicturesRepository (abstract)
        │   └── usecases/       ← GetPicturesUsecase
        ├── presentation/
        │   └── home/
        │       ├── home_presenter_impl.dart    ← implements HomePresenter
        │       └── home_state.dart             ← sealed state classes
        └── ui/
            ├── home/
            │   ├── home_page.dart
            │   ├── home_presenter.dart         ← abstract interface with ValueNotifiers
            │   └── widgets/
            │       └── picture_list_tile_widget.dart
            └── details/
                └── details_page.dart
```

---

## Key Architectural Rules

1. **Adapter Pattern everywhere in `core/infrastructure/`** — every third-party package (Dio, SharedPreferences, GetIt) is hidden behind an abstract interface. Never use these packages directly outside their adapter files.
2. **`AppError` is the only error type** — all layers catch raw exceptions and rethrow as `AppError(type: AppErrorType.xxx, exception: e)`. Never let raw `DioException`, `PlatformException`, etc. propagate.
3. **No direct `GetIt.instance` access outside `GetItAdapter`** — UI and business logic always go through `DependencyInjector` / `GetItAdapter`.
4. **New modules follow the `pictures` module exactly** — same four sub-layers (data/domain/presentation/ui), same file naming conventions.
5. **Register ALL new dependencies in `AppDependencies.registerAppDependencies()`** — order matters: infrastructure → datasources → repository → usecase → presenter.

---

## Known Issues

- `mocktail: ^1.0.0` is listed under `dependencies` (production) in `pubspec.yaml`. It should be under `dev_dependencies`. Do not introduce more test-only packages into production dependencies.
- `NetworkConnectionController.hasConnection()` performs a DNS lookup against `www.flutter.dev` using `dart:io` — this will not work on Flutter Web targets.
