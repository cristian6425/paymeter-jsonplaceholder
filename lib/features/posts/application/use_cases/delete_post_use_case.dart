import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/application/use_cases/use_case.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/repositories/posts_repository.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/repositories/i_posts_repository.dart';

class DeletePostInput {
  const DeletePostInput({
    required this.id,
  });

  final int id;
}

class DeletePostUseCase extends UseCase<DeletePostInput, void> {
  DeletePostUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  AsyncResult<void> call(DeletePostInput params) async {
    if (params.id <= 0) {
      return FailureResult(
        ValidationFailure(message: 'Identificador inválido.'),
      );
    }
    return _repository.deletePost(params.id);
  }
}

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return DeletePostUseCase(repository);
});
