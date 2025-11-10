import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/application/use_cases/use_case.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/repositories/posts_repository.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/create_post_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/value_objects/post_value_objects.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/repositories/i_posts_repository.dart';

class CreatePostInput {
  const CreatePostInput({
    required this.title,
    required this.body,
    this.userId = CreatePostParams.defaultUserId,
  });

  final String title;
  final String body;
  final int userId;
}

class CreatePostUseCase extends UseCase<CreatePostInput, PostModel> {
  CreatePostUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  AsyncResult<PostModel> call(CreatePostInput params) async {
    final titleResult = PostTitle.create(params.title);
    if (titleResult.isFailure) {
      return FailureResult(titleResult.failureOrNull!);
    }

    final bodyResult = PostBody.create(params.body);
    if (bodyResult.isFailure) {
      return FailureResult(bodyResult.failureOrNull!);
    }

    final createParams = CreatePostParams(
      title: titleResult.valueOrNull!,
      body: bodyResult.valueOrNull!,
      userId: params.userId,
    );

    return _repository.createPost(createParams);
  }
}

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return CreatePostUseCase(repository);
});
