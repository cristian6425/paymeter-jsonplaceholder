import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/application/use_cases/use_case.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/repositories/posts_repository.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/update_post_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/value_objects/post_value_objects.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/repositories/i_posts_repository.dart';

class UpdatePostInput {
  const UpdatePostInput({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  final int id;
  final String title;
  final String body;
  final int userId;
}

class UpdatePostUseCase extends UseCase<UpdatePostInput, PostModel> {
  UpdatePostUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  AsyncResult<PostModel> call(UpdatePostInput params) async {
    if (params.id <= 0) {
      return FailureResult(
        ValidationFailure(message: 'Invalid post id.'),
      );
    }

    final titleResult = PostTitle.create(params.title);
    if (titleResult.isFailure) {
      return FailureResult(titleResult.failureOrNull!);
    }

    final bodyResult = PostBody.create(params.body);
    if (bodyResult.isFailure) {
      return FailureResult(bodyResult.failureOrNull!);
    }

    final updateParams = UpdatePostParams(
      id: params.id,
      title: titleResult.valueOrNull!,
      body: bodyResult.valueOrNull!,
      userId: params.userId,
    );

    return _repository.updatePost(updateParams);
  }
}

final updatePostUseCaseProvider = Provider<UpdatePostUseCase>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return UpdatePostUseCase(repository);
});
