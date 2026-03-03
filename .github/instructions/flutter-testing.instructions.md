---
name: Flutter Testing Standards
description: Rules for all test files — mocking, structure, fixtures, and coverage
applyTo: test/**/*.dart
---

# Flutter Testing Standards

## Tooling

- **Always use `mocktail`** for mocking. Never use `mockito` or manual fakes.
- **Never mock concrete implementations** — only mock abstract interfaces:
  ```dart
  // ✅ correct
  class MockPicturesRepository extends Mock implements PicturesRepository {}

  // ❌ wrong
  class MockPicturesRepositoryImpl extends Mock implements PicturesRepositoryImpl {}
  ```

## File Structure

- Test file location **must mirror** the source file path exactly:
  - `lib/modules/pictures/domain/usecases/get_pictures_usecase.dart`
  - → `test/modules/pictures/domain/usecases/get_pictures_usecase_test.dart`
- Use `group()` to organize by class name, then by method or scenario:
  ```dart
  group('GetPicturesUsecase', () {
    group('call()', () {
      test('should return list of pictures when repository succeeds', ...);
      test('should throw AppError when repository throws', ...);
    });
  });
  ```

## Shared Fixtures

- Reuse the shared fixture: `test/modules/pictures/mock/picture_list_mock.dart`.
- Never duplicate fixture data inline in individual test files.
- If a new feature needs fixtures, create a dedicated mock file:  
  `test/modules/<feature>/mock/<entity>_list_mock.dart`.

## Setup Pattern

```dart
late MockDependency mockDep;

setUpAll(() {
  registerFallbackValue(MyCustomType()); // required for any() with custom types
});

setUp(() {
  mockDep = MockDependency();
});
```

- Always call `registerFallbackValue()` in `setUpAll()` for **every custom type** used with `any()`.
- Initialize mocks in `setUp()`, not at the class level.

## Presenter Test Pattern

Use the `listenStates()` helper to track state transitions and assert their sequence:

```dart
List<SomeState> listenStates(SomePresenter presenter) {
  final states = <SomeState>[];
  presenter.state.addListener(() => states.add(presenter.state.value));
  return states;
}

test('should emit Loading then Success', () async {
  final states = listenStates(presenter);
  await presenter.getPictures();
  expect(states[0], isA<SomeStateLoading>());
  expect(states[1], isA<SomeStateSuccess>());
});
```

## Widget Test Pattern

- Wrap widgets under test in a `MaterialApp` with named routes to enable navigation testing.
- Use `Key`-based finders for interactive elements (buttons, list items):
  ```dart
  await tester.tap(find.byKey(const Key('icon-button-key-0')));
  ```
- Always cover: loading state, success state with data, error state with "Try again" button, and navigation.

## Coverage Expectations

- Every `UseCase`, `Repository`, `Datasource`, and `Presenter` must have a unit test file.
- Every `Page` widget must have a widget test file.
- Run `flutter test --coverage` and verify `./flutter_test_coverage.sh` before submitting.
