import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';

class CommandResponse<T> {
  const CommandResponse._({
    this.data,
    this.message,
    this.failure,
  });

  final T? data;
  final String? message;
  final Failure? failure;

  bool get isSuccessful => failure == null;

  Result<T?> toResult() {
    if (failure != null) {
      return FailureResult<T?>(failure!);
    }
    return Success<T?>(data);
  }

  factory CommandResponse.success({
    T? data,
    String? message,
  }) {
    return CommandResponse._(
      data: data,
      message: message,
    );
  }

  factory CommandResponse.failure(
    Failure failure, {
    String? message,
  }) {
    return CommandResponse._(
      failure: failure,
      message: message,
    );
  }
}
