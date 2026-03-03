# Architecture Guide — nasa_pictures_app

## The Four-Layer Model

Every feature module in this project strictly follows Clean Architecture with four layers. The `lib/modules/pictures/` module is the canonical reference.

```
lib/modules/<feature>/
├── data/          ← Outermost layer: talks to APIs and local storage
├── domain/        ← Core layer: business rules, pure Dart
├── presentation/  ← Presenter logic: state + ValueNotifier
└── ui/            ← Flutter widgets: depends only on abstract Presenter
```

## Layer Dependency Rule

Dependencies flow **inward only**:

```
ui → presentation (abstract interface) → domain → (domain has no outward deps)
data → domain (implements repository interface)
```

Data and UI layers **never** import from each other.

## Canonical File Templates

### Domain Entity
```dart
/// Represents a [FeatureName] item in the domain.
class FeatureName {
  final String id;
  final String title;

  const FeatureName({
    required this.id,
    required this.title,
  });
}
```

### Domain Repository Interface
```dart
import 'package:nasa_pictures_app/modules/<feature>/domain/entities/<entity>.dart';

/// Abstract contract for accessing [FeatureName] data.
abstract class FeatureRepository {
  Future<List<FeatureName>> getItems();
}
```

### Use Case
```dart
import 'package:nasa_pictures_app/modules/<feature>/domain/entities/<entity>.dart';
import 'package:nasa_pictures_app/modules/<feature>/domain/repositories/<feature>_repository.dart';

/// Retrieves a list of [FeatureName] items from the repository.
class GetFeatureUsecase {
  final FeatureRepository repository;

  GetFeatureUsecase({required this.repository});

  Future<List<FeatureName>> call() async {
    return await repository.getItems();
  }
}
```

### DTO
```dart
import 'package:nasa_pictures_app/modules/<feature>/domain/entities/<entity>.dart';

/// Data Transfer Object for mapping raw API/storage data to [FeatureName].
class FeatureNameDto {
  final String id;
  final String title;

  const FeatureNameDto({required this.id, required this.title});

  factory FeatureNameDto.fromMap(Map<String, dynamic> map) {
    return FeatureNameDto(
      id: map['id'] as String,
      title: map['title'] as String,
    );
  }

  FeatureName toEntity() => FeatureName(id: id, title: title);
}
```

### Abstract Datasource
```dart
/// Abstract contract for [FeatureName] data sources.
abstract class FeatureDatasource {
  Future<List<Map<String, dynamic>>> getItems();
}
```

### Remote Datasource
```dart
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/infrastructure/http/http_client.dart';
import 'package:nasa_pictures_app/modules/<feature>/data/datasources/<feature>_datasource.dart';

/// Fetches [FeatureName] data from the remote API.
class FeatureRemoteDatasource implements FeatureDatasource {
  final HttpClient httpClient;

  FeatureRemoteDatasource({required this.httpClient});

  @override
  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final response = await httpClient.request(
        method: "get",
        path: "/your/endpoint",
      );
      final List<Map<String, dynamic>> data = List.from(response.data);
      if (data.isNotEmpty) return data;
      throw AppError(type: AppErrorType.invalidData);
    } on AppError catch (_) {
      rethrow;
    } catch (e) {
      throw AppError(type: AppErrorType.datasource, exception: e);
    }
  }
}
```

### Repository Implementation
```dart
import 'package:nasa_pictures_app/core/error/app_error.dart';
import 'package:nasa_pictures_app/core/utils/network_connection/network_connection_controller.dart';
import 'package:nasa_pictures_app/modules/<feature>/data/datasources/<feature>_datasource.dart';
import 'package:nasa_pictures_app/modules/<feature>/data/dtos/<entity>_dto.dart';
import 'package:nasa_pictures_app/modules/<feature>/domain/entities/<entity>.dart';
import 'package:nasa_pictures_app/modules/<feature>/domain/repositories/<feature>_repository.dart';

/// Implements [FeatureRepository] routing between remote and local data sources.
class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureDatasource remoteDatasource;
  final FeatureDatasource localDatasource;
  final NetworkConnectionController networkConnectionController;

  FeatureRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkConnectionController,
  });

  @override
  Future<List<FeatureName>> getItems() async {
    try {
      late List<Map<String, dynamic>> response;
      final hasConnection = await networkConnectionController.hasConnection();
      response = hasConnection
          ? await remoteDatasource.getItems()
          : await localDatasource.getItems();
      return response.map((e) => FeatureNameDto.fromMap(e).toEntity()).toList();
    } catch (e) {
      throw AppError(type: AppErrorType.repository, exception: e);
    }
  }
}
```

### State Classes
```dart
import 'package:nasa_pictures_app/modules/<feature>/domain/entities/<entity>.dart';

abstract class ScreenState {}

class ScreenStateLoading extends ScreenState {
  ScreenStateLoading();
}

class ScreenStateSuccess extends ScreenState {
  final List<FeatureName> items;
  ScreenStateSuccess({required this.items});
}

class ScreenStateError extends ScreenState {
  final String message;
  ScreenStateError({required this.message});
}
```

### Abstract Presenter Interface
```dart
import 'package:flutter/foundation.dart';
import 'package:nasa_pictures_app/modules/<feature>/presentation/<screen>/<screen>_state.dart';

/// Abstract interface for the [ScreenPage] presenter.
abstract class ScreenPresenter {
  ValueNotifier<ScreenState> get state;

  Future<void> getItems();
  Future<void> refresh();
}
```

### Presenter Implementation
```dart
import 'package:flutter/foundation.dart';
import 'package:nasa_pictures_app/modules/<feature>/domain/usecases/<verb>_<feature>_usecase.dart';
import 'package:nasa_pictures_app/modules/<feature>/presentation/<screen>/<screen>_state.dart';
import 'package:nasa_pictures_app/modules/<feature>/ui/<screen>/<screen>_presenter.dart';

/// Concrete implementation of [ScreenPresenter].
class ScreenPresenterImpl implements ScreenPresenter {
  final GetFeatureUsecase getFeatureUsecase;

  ScreenPresenterImpl({required this.getFeatureUsecase});

  @override
  ValueNotifier<ScreenState> state = ValueNotifier(ScreenStateLoading());

  @override
  Future<void> getItems() async {
    state.value = ScreenStateLoading();
    try {
      final result = await getFeatureUsecase();
      state.value = ScreenStateSuccess(items: result);
    } catch (e) {
      state.value = ScreenStateError(message: "Something went wrong.");
    }
  }

  @override
  Future<void> refresh() async {
    state.value = ScreenStateLoading();
    try {
      final result = await getFeatureUsecase();
      state.value = ScreenStateSuccess(items: result);
    } catch (e) {
      state.value = ScreenStateError(message: "Something went wrong.");
    }
  }
}
```

## AppDependencies Registration Order

```
infrastructure (adapters) → datasources → repositories → usecases → presenters
```

Always use `registerLazySingleton`. Named instances required when registering multiple implementations of the same interface (e.g., remote and local datasources).
