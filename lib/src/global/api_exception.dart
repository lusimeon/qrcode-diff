enum ApiExceptionType { warning, error }

class ApiException implements Exception {
  ApiException({
    this.message = '',
    this.type = ApiExceptionType.error,
  });

  final String? message;

  final ApiExceptionType type;

  @override
  String toString() {
    return message ?? '';
  }
}
