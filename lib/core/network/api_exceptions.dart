/// Typed API exceptions for error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({super.message = 'Session expired. Please login again.'})
      : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  const ForbiddenException({super.message = 'You do not have permission to perform this action.'})
      : super(statusCode: 403);
}

class NotFoundException extends ApiException {
  const NotFoundException({super.message = 'Resource not found.'})
      : super(statusCode: 404);
}

class ConflictException extends ApiException {
  const ConflictException({super.message = 'Conflict: resource already exists.'})
      : super(statusCode: 409);
}

class ServerException extends ApiException {
  const ServerException({super.message = 'Server error. Please try again later.'})
      : super(statusCode: 500);
}

class NetworkException extends ApiException {
  const NetworkException({super.message = 'No internet connection. Please check your network.'})
      : super(statusCode: null);
}

class TimeoutException extends ApiException {
  const TimeoutException({super.message = 'Request timed out. Please try again.'})
      : super(statusCode: null);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    super.message = 'Validation failed.',
    this.errors,
  }) : super(statusCode: 422);
}
