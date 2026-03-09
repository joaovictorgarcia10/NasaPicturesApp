# 🚀 NASA Pictures App

A Flutter mobile application that fetches and displays NASA's **Astronomy Picture of the Day (APOD)** from the [NASA API](https://api.nasa.gov/). Users can browse a paginated list of pictures, search by title or date, pull to refresh, and view full details of each entry.

Built with **Clean Architecture** principles using **Dart 3** and **Flutter**, featuring strong separation of concerns with the Adapter Design Pattern for all third-party dependencies.

<br/>

## ✨ Features

- 📱 **Dual Screen Interface**: Home page with list of images and detail view per image
- 🔍 **Search Functionality**: Find pictures by title or date
- 🖼️ **Image Caching**: Smart caching with `cached_network_image` for optimal performance
- 📡 **Offline Support**: Local caching with SharedPreferences to work offline
- 🔄 **Pull-to-Refresh**: Manually update the feed with latest pictures
- 📄 **Pagination**: Load and browse pictures paginated
- 🎯 **Clean Architecture**: Modular feature-based structure with clear separation of concerns
- 🔌 **Adapter Pattern**: All external dependencies abstracted behind interfaces

<br/>

## 📸 App Preview

<p float="left"> 
  <img src="https://github.com/joaovictorgarcia10/nasa_pictures_app/blob/master/assets/preview_1.png" width="315" height="550"/>
  <img src="https://github.com/joaovictorgarcia10/nasa_pictures_app/blob/master/assets/preview_2.png" width="315" height="550"/>
</p>

<br/>

## 💻 Tech Stack

- **Language**: Dart 3
- **Framework**: Flutter
- **State Management**: `ValueNotifier` for reactive UI state
- **Dependency Injection**: `GetIt` (abstracted via `DependencyInjector`)
- **HTTP Client**: `Dio` (abstracted via `HttpClient`)
- **Local Storage**: `SharedPreferences` (abstracted via `LocalStorageClient`)
- **Image Caching**: `cached_network_image`
- **Testing**: `flutter_test` + `mocktail`

<br/>

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  get_it: ^7.6.4
  dio: ^5.3.2
  shared_preferences: ^2.2.1
  cached_network_image: ^3.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
```

> ⚠️ **Note**: `mocktail` should be in `dev_dependencies`, not `dependencies`

<br/>

## 🏗️ Architecture Overview

This project implements **Clean Architecture** with a **Modular Structure**. Each feature is a self-contained module that manages its own layers and dependencies.

### Project Structure

```
lib/
├── app/
│   ├── app_dependencies.dart        # Global DI registration (LocalStorageClient, NetworkController)
│   └── app_widget.dart              # Root MaterialApp with module-based routing
│
├── core/
│   ├── adapters/                    # Adapter Pattern - abstracts external dependencies
│   │   ├── dependency_injector/     # GetIt abstraction layer
│   │   │   ├── dependency_injector.dart
│   │   │   └── adapter/get_it_adapter.dart
│   │   │
│   │   ├── http/                    # Dio abstraction layer
│   │   │   ├── http_client.dart
│   │   │   ├── http_method.dart
│   │   │   ├── http_response.dart
│   │   │   └── adapter/dio_adapter.dart
│   │   │
│   │   └── local_storage/           # SharedPreferences abstraction layer
│   │       ├── local_storage_client.dart
│   │       └── adapter/shared_preferences_adapter.dart
│   │
│   ├── constants/                   # App-wide constants
│   │   └── app_constants.dart
│   │
│   ├── controllers/
│   │   └── network_connection/      # Network status monitoring
│   │       └── network_connection_controller.dart
│   │
│   └── module_manager/              # Module system for scalable architecture
│       ├── module_contract.dart     # ModuleContract interface
│       ├── module_manager.dart      # ModuleManager mixin (routes, DI registration)
│       └── module_utils.dart        # Utilities (GlobalKey, WidgetBuilderArgs typedef)
│
└── modules/
    └── pictures/                    # Example feature module (template for new features)
        │
        ├── constants/
        │   └── pictures_constants.dart
        │
        ├── data/                    # Data layer - concrete implementations
        │   ├── datasources/
        │   │   ├── pictures_local_datasource.dart   # Local cache implementation
        │   │   └── pictures_remote_datasource.dart  # API implementation
        │   └── dtos/
        │       └── picture_dto.dart                 # DTO → Entity conversion
        │
        ├── domain/                  # Domain layer - business logic & contracts
        │   ├── entities/
        │   │   └── picture.dart                     # Pure Dart entity (no framework)
        │   ├── repositories/
        │   │   └── pictures_repository.dart         # Repository interface
        │   └── usecases/
        │       └── get_pictures_usecase.dart        # Business logic
        │
        ├── infrastructure/          # Infrastructure layer - data orchestration
        │   ├── datasources/
        │   │   └── pictures_datasource.dart         # Datasource interface
        │   └── repositories/
        │       └── pictures_repository_impl.dart    # Repository implementation
        │
        ├── presentation/            # Presentation layer - UI state management
        │   ├── pages/
        │   │   ├── home/
        │   │   │   ├── home_page.dart
        │   │   │   ├── presenter/
        │   │   │   │   ├── home_presenter.dart      # Presenter interface
        │   │   │   │   ├── home_presenter_impl.dart # Presenter implementation
        │   │   │   │   └── home_state.dart          # State classes (sealed)
        │   │   │   └── widgets/
        │   │   │       ├── picture_list_tile_widget.dart
        │   │   │       └── picture_app_bar_widget.dart
        │   │   └── details/
        │   │       └── details_page.dart
        │   └── helpers/
        │       └── date_formater_extension.dart
        │
        └── pictures_module.dart     # ModuleContract implementation
```

### Architecture Layers Explained

Each module follows a **4-layer Clean Architecture**:

#### 1. **Domain Layer** (`domain/`)
Pure business logic layer with NO framework dependencies.

- **Entities**: Core Dart classes representing business objects
- **Repositories**: Abstract interfaces defining data contracts  
- **Usecases**: Business logic encapsulation (e.g., `GetPicturesUsecase`)

Example:
```dart
// Pure Dart - no Flutter imports
class Picture {
  final int id;
  final String title;
  final String explanation;
  // ...
}

abstract class PicturesRepository {
  Future<List<Picture>> getPictures({int page});
}

class GetPicturesUsecase {
  final PicturesRepository _repository;
  Future<List<Picture>> call({int page}) => _repository.getPictures(page: page);
}
```

#### 2. **Data Layer** (`data/`)
Concrete implementations of data fetching and storage.

- **Remote Datasources**: API implementation (uses `HttpClient` adapter)
- **Local Datasources**: Cache implementation (uses `LocalStorageClient` adapter)
- **DTOs**: Data Transfer Objects for serialization/deserialization

#### 3. **Infrastructure Layer** (`infrastructure/`)
Bridges between data and domain layers.

- **Datasource Interface**: Abstract interface for datasources
- **Repository Implementation**: Uses remote + local datasources, handles business logic (online/offline fallback, caching, error handling)

#### 4. **Presentation Layer** (`presentation/`)
UI logic with reactive state management using `ValueNotifier`.

- **Pages**: Full-screen UI components
- **Presenters**: Business logic orchestration with `ValueNotifier` for reactive updates
- **State Classes**: Sealed state classes representing different UI states
- **Widgets**: Reusable UI components

<br/>

### Module System

The app uses a **ModuleManager** for scalable, feature-based architecture:

```dart
// AppWidget registers all modules
class AppWidget extends StatelessWidget with ModuleManager {
  AppWidget({super.key}) {
    super.registerRoutes();        // Register all module routes
    super.registerDependencies();  // Register all module dependencies
  }

  @override
  List<ModuleContract> get modules => [PicturesModule()];
}

// Each module implements ModuleContract
class PicturesModule implements ModuleContract {
  @override
  String get moduleName => "PicturesModule";
  
  @override
  void Function() get registerDependencies => () {
    injector
      ..registerFactory<HttpClient>(/* ... */)
      ..registerFactory<PicturesRemoteDatasource>(/* ... */)
      ..registerFactory<PicturesLocalDatasource>(/* ... */)
      ..registerFactory<PicturesRepository>(/* ... */)
      ..registerFactory<GetPicturesUsecase>(/* ... */)
      ..registerFactory<HomePresenter>(/* ... */);
  };
  
  @override
  Map<String, WidgetBuilderArgs> get routes => {
    "/": (context, args) => HomePage(presenter: injector.get<HomePresenter>()),
    "/details": (context, args) => DetailsPage(picture: args as Picture),
  };
}
```

**Benefits:**
- ✅ **Self-contained modules**: Each module is independent with its own DI
- ✅ **Automatic route registration**: Routes collected from all modules
- ✅ **Scalable**: Add new features by creating new modules following the same pattern
- ✅ **Manageable dependencies**: Each module registers only its own dependencies in proper order

<br/>

### Adapter Pattern

All external packages are abstracted behind interfaces in `core/adapters/`:

```dart
// ✅ Use through adapter interface
final httpClient = injector.get<HttpClient>();  // Abstracted
await httpClient.get(url);

// ❌ Never use directly
import 'package:dio/dio.dart';  // Forbidden outside adapter
await Dio().get(url);

// ✅ Adapter implementation (only in adapter files)
class DioAdapter implements HttpClient {
  final Dio _dio;
  
  @override
  Future<HttpResponse> get(String url) async {
    final response = await _dio.get(url);
    return HttpResponse(data: response.data);
  }
}
```

**Supported Adapters:**
- 🔌 **DependencyInjector**: GetIt wrapped behind `DependencyInjector` interface
- 🌐 **HttpClient**: Dio wrapped behind `HttpClient` interface  
- 💾 **LocalStorageClient**: SharedPreferences wrapped behind `LocalStorageClient` interface

<br/>

### Key Architectural Principles

1. **Adapter Pattern Everywhere** 🔌
   - All third-party packages hidden behind abstract interfaces
   - Never use external packages directly outside adapters
   - Easy to swap implementations (e.g., replace Dio with HTTP package)

2. **Unidirectional Dependency Flow** ⬇️
   - `Presentation` → `Domain` → `Data` → `Infrastructure`
   - No backwards dependencies (data doesn't import presentation)
   - Domain layer is framework-independent

3. **ValueNotifier for State Management** 📊
   - No external state management packages (bloc, provider, riverpod)
   - Presenters expose `ValueNotifier` for reactive updates
   - Simple, lightweight, and testable

4. **Modular Structure** 📦
   - Features are self-contained modules
   - New features follow the `pictures` module exactly
   - Easy to add/remove features without affecting others

5. **Proper Dependency Registration Order** 🔧
   - Infrastructure (adapters) → Datasources → Repository → Usecase → Presenter
   - Registered in module's `registerDependencies()` function
   - Lazy registration with `registerFactory` for modules, `registerLazySingleton` for global dependencies

<br/>

<br/>

## 🚀 Prerequisites

- **Flutter**: 3.10.6 or later ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Dart**: 3.0 or later (included with Flutter)
- **Android**: SDK (API level 21+) or Android Studio
- **iOS**: Xcode 11+ and iOS 12.0+
- **NASA API Key**: Free key from [api.nasa.gov](https://api.nasa.gov/)

<br/>

## 🔧 Environment Configuration

Environment variables are passed via `--dart-define` at compile time. There is **no `.env` file**.

### Required Variables

```bash
--dart-define=API_BASE_URL=https://api.nasa.gov
--dart-define=API_KEY=<YOUR_NASA_API_KEY>
```

> ⚠️ If not provided, API calls will fail silently. Ensure both values are set at runtime.

<br/>

## 📥 Installation & Setup

1. **Clone the repository**:
```bash
git clone https://github.com/joaovictorgarcia10/nasa_pictures_app.git
cd nasa_pictures_app
```

2. **Get your NASA API key**:
   - Visit [api.nasa.gov](https://api.nasa.gov/)
   - Sign up and generate a free API key

3. **Install Flutter dependencies**:
```bash
flutter pub get
```

4. **Run on connected device/simulator**:
```bash
flutter run \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=YOUR_API_KEY_HERE
```

Or use the provided script (update it with your API key first):
```bash
bash flutter_run.sh
```

<br/>

## 🏗️ Building for Production

### Android (Release APK)
```bash
flutter build apk \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=YOUR_API_KEY
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android (App Bundle for Play Store)
```bash
flutter build appbundle \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=YOUR_API_KEY
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS
```bash
flutter build ios \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=YOUR_API_KEY
```

### Code Obfuscation (Recommended for Production)
```bash
flutter build apk \
  --obfuscate \
  --split-debug-info=./symbols \
  --dart-define=API_BASE_URL=https://api.nasa.gov \
  --dart-define=API_KEY=YOUR_API_KEY
```

See [Obfuscate Dart code](https://docs.flutter.dev/deployment/obfuscate) for details.

<br/>

## ✅ Testing

### Run All Tests
```bash
flutter test
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

Generates: `coverage/lcov.info`

### Generate HTML Coverage Report (macOS)
```bash
# Install lcov if needed
brew install lcov

# Generate HTML report
bash flutter_test_coverage.sh

# Open report
open coverage/html/index.html
```

<p>
  <img src="https://github.com/joaovictorgarcia10/nasa_pictures_app/blob/master/assets/coverage.png" width="100%"/>
</p>

<br/>

## 🔍 Code Quality

### Static Analysis
Must exit with code 0 before committing:
```bash
flutter analyze
```

### Code Formatting
```bash
dart format lib/ test/
```

### Pre-commit Checklist
- ✅ `flutter test` passes
- ✅ `flutter analyze` exits with 0
- ✅ Code formatted with `dart format`

<br/>

## 📚 Creating New Features

New features should follow the **`pictures` module structure exactly**:

### 1. Create Module Structure
```bash
lib/modules/
└── my_feature/
    ├── constants/
    ├── data/
    │   ├── datasources/
    │   └── dtos/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    ├── infrastructure/
    │   ├── datasources/
    │   └── repositories/
    ├── presentation/
    │   ├── pages/
    │   │   └── main_page.dart
    │   └── helpers/
    └── my_feature_module.dart
```

### 2. Implementation Order
1. **Domain Layer**: Define entities, repository interface, usecase
2. **Data Layer**: Create DTOs, remote/local datasources
3. **Infrastructure Layer**: Implement datasource interface, repository implementation
4. **Presentation Layer**: Build presenters, pages, widgets
5. **Module File**: Create `MyFeatureModule` implementing `ModuleContract`

### 3. Register Module
Add to `AppWidget`:
```dart
@override
List<ModuleContract> get modules => [
  PicturesModule(),
  MyFeatureModule(),  // Add here
];
```

### 4. Dependency Registration Order
In `my_feature_module.dart`:
```dart
registerDependencies: () {
  injector
    // 1. Infrastructure (adapters)
    ..registerFactory<HttpClient>(instance: DioAdapter(/* ... */))
    
    // 2. Datasources
    ..registerFactory<MyDatasource>(instance: MyDatasourceImpl(/* ... */))
    
    // 3. Repository
    ..registerFactory<MyRepository>(instance: MyRepositoryImpl(/* ... */))
    
    // 4. Usecase
    ..registerFactory<MyUsecase>(instance: MyUsecase(/* ... */))
    
    // 5. Presenter
    ..registerFactory<MyPresenter>(instance: MyPresenterImpl(/* ... */));
}
```

<br/>


## 🔐 Security Best Practices

**Never commit API keys or sensitive data**:

- ✅ For development: Use `flutter_run.sh` or `.vscode/launch.json` (add to `.gitignore`)
- ✅ For CI/CD: Set `--dart-define` values only in CI environment variables
- ✅ For production: Use code obfuscation and environment-specific builds

<br/>

## 📄 License

This project is open source and available under the MIT License.

<br/>

## 👤 Author

[João Victor Garcia](https://github.com/joaovictorgarcia10)

<br/>
















