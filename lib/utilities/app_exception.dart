// This file handles all types of exceptions that can be thrown anywhere in the
// application
abstract class AppException implements Exception {
  final String message;
  final String prefix;
  final String url;

  AppException({
    required this.message,
    required this.prefix,
    required this.url,
  });
}

class BadRequestException extends AppException {
  BadRequestException(String message, String url)
      : super(message: message, prefix: 'Bad request', url: url);
}

class FetchDataException extends AppException {
  FetchDataException(String message, String url)
      : super(
          message: message,
          prefix: 'Unable to process the request',
          url: url,
        );
}

class ApiNotRespondingException extends AppException {
  ApiNotRespondingException(String message, String url)
      : super(message: message, prefix: 'Api not responding', url: url);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String message, String url)
      : super(message: message, prefix: 'Unauthorized request', url: url);
}

class NotFoundException extends AppException {
  NotFoundException(String message, String url)
      : super(message: message, prefix: 'Page not found', url: url);
}
