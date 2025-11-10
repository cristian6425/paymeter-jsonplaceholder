import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/application/use_cases/use_case.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/repositories/posts_repository.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/paginated_posts.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/pagination_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/repositories/i_posts_repository.dart';

class FetchPostsUseCase extends UseCase<PaginationParams, PaginatedPosts> {
  FetchPostsUseCase(this._repository);

  final IPostsRepository _repository;

  @override
  AsyncResult<PaginatedPosts> call(PaginationParams params) {
    final sanitized = params.sanitized();
    return _repository.getPosts(sanitized);
  }
}

final fetchPostsUseCaseProvider = Provider<FetchPostsUseCase>((ref) {
  final repository = ref.watch(postsRepositoryProvider);
  return FetchPostsUseCase(repository);
});
