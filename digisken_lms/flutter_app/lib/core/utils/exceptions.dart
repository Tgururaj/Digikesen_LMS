class AppException implements Exception {
  final String message;
  final String? code;

  AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({required String message}) : super(message: message);
}

class ServerException extends AppException {
  ServerException({required String message}) : super(message: message);
}

class CacheException extends AppException {
  CacheException({required String message}) : super(message: message);
}
