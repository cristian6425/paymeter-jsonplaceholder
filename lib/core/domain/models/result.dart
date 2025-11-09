import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    if (self is Success<T>) {
      return success(self.value);
    }
    return failure((self as FailureResult<T>).failure);
  }

  Result<R> map<R>(R Function(T data) transform) {
    final self = this;
    if (self is Success<T>) {
      return Success<R>(transform(self.value));
    }
    return FailureResult<R>((self as FailureResult<T>).failure);
  }

  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    final self = this;
    if (self is Success<T>) {
      return transform(self.value);
    }
    return FailureResult<R>((self as FailureResult<T>).failure);
  }

  T? get valueOrNull => this is Success<T> ? (this as Success<T>).value : null;

  Failure? get failureOrNull =>
      this is FailureResult<T> ? (this as FailureResult<T>).failure : null;
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}

typedef AsyncResult<T> = Future<Result<T>>;
