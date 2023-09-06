enum AppErrorType {
  httpRequest,
  httpResponse,
  invalidData,
  domain,
}

class AppError implements Exception {
  final AppErrorType type;
  final Object? exception;

  AppError({
    required this.type,
    this.exception,
  });
}
