---
name: fix-and-run-tests
description: Runs the full Flutter test suite, analyzes failures, fixes them at the root cause, and re-runs until all tests pass. Use when tests are failing or before opening a PR.
compatibility: Requires Flutter SDK installed and a connected device/simulator not needed (unit/widget tests only).
---

# Skill: Fix and Run Tests

Run the full test suite for this Flutter project, diagnose any failures, fix them, and re-run until clean.

## When to Use This Skill

- Tests are failing after a code change
- Before opening a pull request (CI gate check)
- After generating new code (verifying no regressions)
- Periodic quality audit

## Step-by-Step Workflow

### 1. Run the full test suite

```bash
flutter test
```

Capture the full output. Note:
- Which test files failed
- The exact error messages and stack traces
- Whether failures are in unit tests, widget tests, or both

### 2. Analyze failures — categorize before fixing

For each failing test, determine the root cause:

| Category | Signs | Fix Approach |
|---|---|---|
| **Broken mock setup** | `Null check operator used on a null value` in setUp | Fix `registerFallbackValue()` or mock initialization |
| **Wrong state expected** | `Expected: <StateX> Actual: <StateY>` | Fix the presenter/usecase logic or update the test assertion |
| **Missing stub** | `MissingStubError: 'methodName'` from mocktail | Add `when(() => mock.method()).thenReturn(...)` |
| **Widget not found** | `Found 0 widgets with key/text` | Fix widget key or text, or update the widget build |
| **Navigation failure** | `'Navigator operation requested with a context...'` | Wrap widget in `MaterialApp` with named routes |
| **Compile error** | `Error: ...` before test execution | Fix Dart syntax or missing imports |

### 3. Fix at the root cause

- **Never comment out a failing test** — fix the underlying issue.
- If the test assertion is wrong (source code changed intentionally), update the test.
- If the source code has a bug exposed by the test, fix the source code.
- When fixing mock stubs, check all `when()` calls match the current method signatures.

### 4. Re-run until clean

```bash
flutter test
```

Repeat fix → re-run until output shows:

```
All tests passed!
```

### 5. Run static analysis

```bash
flutter analyze
```

Fix any warnings or errors. Must exit 0.

### 6. Optional: Generate coverage report

```bash
flutter test --coverage
./flutter_test_coverage.sh
```

Review `coverage/html/index.html` for any newly uncovered lines.

## Common Project-Specific Issues

- **`mocktail` fallback values** — if a method takes a custom type (e.g., `Picture`) as parameter, `registerFallbackValue(Picture(...))` must be called in `setUpAll()`.
- **Fixture data** — always use `test/modules/pictures/mock/picture_list_mock.dart` for `Picture` list fixtures. Never hardcode inline JSON in test files.
- **`listenStates()` pattern** — presenter state tests must use the listener helper to capture all state transitions, not just the final state.
- **Named routes in widget tests** — `HomePage` and `DetailsPage` tests must wrap in a `MaterialApp` with the `/` and `/details` routes defined.
