enum AppErrorType {
  httpRequest,
  httpResponse,
  invalidData,
  localStorage,
  localStorageEmptyData,
}

class AppError implements Exception {
  final AppErrorType type;
  final Object? exception;

  AppError({required this.type, this.exception});
}
