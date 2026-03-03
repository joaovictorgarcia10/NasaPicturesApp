#!/bin/zsh
# run_tests.sh — Execute the full test suite with coverage for nasa_pictures_app
# Usage: ./scripts/run_tests.sh [--coverage]

set -e

echo "🔍 Running flutter analyze..."
flutter analyze

echo ""
echo "🧪 Running flutter test..."

if [[ "$1" == "--coverage" ]]; then
  flutter test --coverage
  echo ""
  echo "📊 Generating HTML coverage report..."
  genhtml coverage/lcov.info -o coverage/html --quiet
  echo "✅ Coverage report available at: coverage/html/index.html"
else
  flutter test
fi

echo ""
echo "✅ All checks passed."
