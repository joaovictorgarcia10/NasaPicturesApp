---
name: new-feature-module
description: Scaffolds a complete new Clean Architecture feature module for this Flutter app. Use when adding a new feature (e.g., favorites, settings, profile). Creates all four layers (data, domain, presentation, ui) plus mirrored test files.    
compatibility: Requires access to lib/ and test/ directories.
---

# Skill: New Feature Module

Scaffold a complete new Clean Architecture feature module for this Flutter project.

## When to Use This Skill

- Adding a new feature module (e.g., `favorites`, `settings`, `profile`, `search`)
- The feature requires its own data fetching, domain logic, and UI

## Prerequisites

- Know the **feature name** (e.g., `favorites`) — this becomes the folder name and drives all class naming
- Know the **primary entity** the feature works with (e.g., `Favorite`, `UserSettings`)
- Know the **primary use case verb** (e.g., `Get`, `Save`, `Delete`)

## Step-by-Step Workflow

### 1. Read the canonical reference module first

Before creating any file, read the entire `lib/modules/pictures/` directory tree. This is the **single source of truth** for all naming, structure, and patterns.

Also read `lib/app/app_dependencies.dart` to understand the DI registration pattern.

### 2. Create the domain layer (no external dependencies allowed)

```
lib/modules/<feature>/domain/
├── entities/
│   └── <entity>.dart              ← Pure Dart class, no package imports
├── repositories/
│   └── <feature>_repository.dart  ← abstract class <Feature>Repository
└── usecases/
    └── <verb>_<feature>_usecase.dart ← class <Verb><Feature>Usecase { final <Feature>Repository repository; Future<List/<Entity>> call() }
```

### 3. Create the data layer

```
lib/modules/<feature>/data/
├── datasources/
│   ├── <feature>_datasource.dart         ← abstract class <Feature>Datasource
│   ├── <feature>_remote_datasource.dart  ← implements <Feature>Datasource, uses HttpClient
│   └── <feature>_local_datasource.dart   ← implements <Feature>Datasource, uses LocalStorageClient
├── dtos/
│   └── <entity>_dto.dart                 ← static fromMap() + toEntity()
└── repositories/
    └── <feature>_repository_impl.dart    ← implements <Feature>Repository
```

### 4. Create the presentation layer

```
lib/modules/<feature>/presentation/<screen>/
├── <screen>_state.dart        ← abstract class + Loading/Success/Error subclasses
└── <screen>_presenter_impl.dart ← implements <Screen>Presenter
```

### 5. Create the UI layer

```
lib/modules/<feature>/ui/<screen>/
├── <screen>_presenter.dart    ← abstract class with ValueNotifier getters
├── <screen>_page.dart         ← StatefulWidget, receives Presenter via constructor
└── widgets/
    └── <entity>_list_tile_widget.dart
```

### 6. Register in AppDependencies

Open `lib/app/app_dependencies.dart` and add registrations in this order:
1. Local datasource (named instance)
2. Remote datasource (named instance)  
3. Repository implementation
4. UseCase
5. Presenter implementation

### 7. Add the route to AppWidget

Open `lib/app/app_widget.dart` and add:
```dart
"/<feature>": (context) => <Screen>Page(presenter: injector.get<<Screen>Presenter>()),
```

### 8. Create mirrored test files

For every file created in `lib/`, create a corresponding `_test.dart` in `test/` at the same relative path:

```
test/modules/<feature>/
├── mock/
│   └── <entity>_list_mock.dart        ← 2–3 fixture records
├── data/
│   ├── datasources/
│   │   ├── <feature>_remote_datasource_test.dart
│   │   └── <feature>_local_datasource_test.dart
│   ├── dtos/
│   │   └── <entity>_dto_test.dart
│   └── repositories/
│       └── <feature>_repository_impl_test.dart
├── domain/
│   └── usecases/
│       └── <verb>_<feature>_usecase_test.dart
├── presentation/
│   └── <screen>/
│       └── <screen>_presenter_impl_test.dart
└── ui/
    └── <screen>/
        └── <screen>_page_test.dart
```

### 9. Validate

Run `flutter analyze` and `flutter test` and fix any issues before reporting completion.

## References

See [Architecture Guide](references/architecture-guide.md) for layer rules and the module structure template.
