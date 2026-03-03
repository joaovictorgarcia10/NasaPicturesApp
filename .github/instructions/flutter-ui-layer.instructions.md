---
name: Flutter UI Layer Rules
description: Rules for UI widgets and pages in the ui/ layer
applyTo: lib/**/ui/**/*.dart
---

# Flutter UI Layer Rules

## Dependency on Presenter Interface Only

- Widgets must **only depend on the abstract `Presenter` interface**, never on `PresenterImpl`:
  ```dart
  // ✅ correct
  class HomePage extends StatefulWidget {
    final HomePresenter presenter;
    const HomePage({required this.presenter, super.key});
  }

  // ❌ wrong — never inject the concrete implementation into a widget
  class HomePage extends StatefulWidget {
    final HomePresenterImpl presenter;
  }
  ```
- Inject the presenter via the route definition in `AppWidget`, not inside the widget itself.

## Obtaining the Presenter via DI

- The `Presenter` must be obtained from `GetItAdapter` at the **route level** in `app_widget.dart`, not inside the widget's `build()`:
  ```dart
  // ✅ in app_widget.dart routes map
  "/": (context) => HomePage(presenter: injector.get<HomePresenter>()),

  // ❌ never call GetItAdapter() inside a widget's build() or initState()
  ```

## Reactive State with ValueNotifier

- Use `AnimatedBuilder` with `Listenable.merge` to react to multiple `ValueNotifier`s simultaneously:
  ```dart
  AnimatedBuilder(
    animation: Listenable.merge([presenter.state, presenter.shouldPaginate]),
    builder: (context, _) {
      final state = presenter.state.value;
      // render based on state
    },
  )
  ```
- Never use `setState()` to react to presenter changes.
- Always dispose `ValueNotifier`s in `dispose()`:
  ```dart
  @override
  void dispose() {
    presenter.state.dispose();
    super.dispose();
  }
  ```

## Widget Decomposition

- Extract reusable UI pieces to dedicated widget classes in a `widgets/` subfolder:
  - `lib/modules/<feature>/ui/<screen>/widgets/<name>_widget.dart`
- Prefer separate `StatelessWidget` subclasses over private methods returning `Widget`.
- Use `const` constructors for all widgets that do not change after construction.

## Navigation

- Use `Navigator.pushNamed(context, '/route', arguments: entity)` for navigation.
- Retrieve route arguments with `ModalRoute.of(context)!.settings.arguments`.
- Never hardcode route strings inline — define route constants if the number of routes grows.

## Code Style

- Never use `print()` — use `debugPrint()` or `log()` from `dart:developer`.
- All public widget classes must have `///` doc comments.
- Prefer `const` constructors everywhere possible.
