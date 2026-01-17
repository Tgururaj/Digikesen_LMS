abstract class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final String? code;

  Failure({required this.message, this.code});
}

class Loading<T> extends Result<T> {}
