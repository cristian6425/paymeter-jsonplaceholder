import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/application/use_cases/use_case.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/repositories/posts_repository.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/repositories/i_posts_repository.dart';

class FetchPostDetailParams {
  const FetchPostDetailParams(this.id) : assert(id > 0, 'id must be positive');

  final int id;
}

class FetchPostDetailUseCase
    extends UseCase<FetchPostDetailParams, PostModel> {
  FetchPostDetailUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  AsyncResult<PostModel> call(FetchPostDetailParams params) {
    return _repository.getPost(params.id);
  }
}

final fetchPostDetailUseCaseProvider =
    Provider<FetchPostDetailUseCase>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return FetchPostDetailUseCase(repository);
});
