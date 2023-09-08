enum AppErrorType {
  dependencyInjector,
  httpRequest,
  httpResponse,
  localStorage,
  invalidData,
  emptyData,
}

class AppError implements Exception {
  final AppErrorType type;
  final Object? exception;

  AppError({required this.type, this.exception});
}
