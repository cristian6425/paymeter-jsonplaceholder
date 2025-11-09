import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';

/// Base interface for every application use case. Keeps the API consistent and
/// guarantees that all interactions return a typed [Result].
abstract class UseCase<Params, Output> {
  const UseCase();

  AsyncResult<Output> call(Params params);
}

/// Helper base for use cases without params. Subclasses override [call] and can
/// consume [execute] from the presentation layer.
abstract class NoParamsUseCase<Output> extends UseCase<NoParams, Output> {
  const NoParamsUseCase();

  AsyncResult<Output> execute() => call(const NoParams());
}

/// Helper value object for use cases without inputs.
class NoParams {
  const NoParams();
}

/// Specialization for commands that only need to signal completion.
abstract class CompletableUseCase<Params> extends UseCase<Params, void> {
  const CompletableUseCase();
}
