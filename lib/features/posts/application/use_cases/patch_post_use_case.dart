import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/application/use_cases/use_case.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/repositories/posts_repository.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/update_post_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/value_objects/post_value_objects.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/repositories/i_posts_repository.dart';

class PatchPostInput {
  const PatchPostInput({
    required this.id,
    this.title,
    this.body,
    this.userId,
  });

  final int id;
  final String? title;
  final String? body;
  final int? userId;
}

class PatchPostUseCase extends UseCase<PatchPostInput, PostModel> {
  PatchPostUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  AsyncResult<PostModel> call(PatchPostInput params) async {
    if (params.id <= 0) {
      return FailureResult(
        ValidationFailure(message: 'Invalid post id.'),
      );
    }

    PostTitle? titleVO;
    if (params.title != null) {
      final result = PostTitle.create(params.title!);
      if (result.isFailure) {
        return FailureResult(result.failureOrNull!);
      }
      titleVO = result.valueOrNull;
    }

    PostBody? bodyVO;
    if (params.body != null) {
      final result = PostBody.create(params.body!);
      if (result.isFailure) {
        return FailureResult(result.failureOrNull!);
      }
      bodyVO = result.valueOrNull;
    }

    if (params.title == null &&
        params.body == null &&
        params.userId == null) {
      return FailureResult(
        ValidationFailure(message: 'Nothing to update.'),
      );
    }

    final patchParams = PatchPostParams(
      id: params.id,
      title: titleVO,
      body: bodyVO,
      userId: params.userId,
    );

    return _repository.patchPost(patchParams);
  }
}

final patchPostUseCaseProvider = Provider<PatchPostUseCase>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return PatchPostUseCase(repository);
});
