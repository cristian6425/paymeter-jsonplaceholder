import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/data/errors/data_error.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/data_sources/i_posts_data_source.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/data_sources/posts_api_data_source.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/paginated_posts.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/pagination_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/repositories/i_posts_repository.dart';

class PostsRepository implements IPostsRepository {
  PostsRepository({
    required IPostsDataSource dataSource,
  }) : _dataSource = dataSource;

  final IPostsDataSource _dataSource;

  @override
  AsyncResult<PaginatedPosts> getPosts(PaginationParams params) async {
    try {
      final sanitized = params.sanitized();
      final rawPosts = await _dataSource.fetchPosts(
        start: sanitized.start,
        limit: sanitized.limit,
      );
      final items =
          rawPosts.map((json) => _mapJsonToPostModel(json)).toList(growable: false);
      final hasMore = items.length == sanitized.limit;
      final nextStart = sanitized.start + items.length;

      return Success(
        PaginatedPosts(
          items: items,
          nextStart: nextStart,
          hasMore: hasMore,
        ),
      );
    } on DataError catch (error) {
      return FailureResult(_mapDataErrorToFailure(error));
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'No se pudo cargar la lista de posts.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncResult<PostModel> getPost(int id) async {
    try {
      final json = await _dataSource.fetchPost(id);
      return Success(_mapJsonToPostModel(json));
    } on DataError catch (error) {
      return FailureResult(_mapDataErrorToFailure(error));
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'No se pudo obtener el detalle del post.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  Failure _mapDataErrorToFailure(DataError error) {
    if (error is NetworkError) {
      return NetworkFailure(
        message: error.message,
        statusCode: error.statusCode,
        cause: error,
        isTimeout: error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout,
      );
    }

    if (error is ApiError) {
      switch (error.statusCode) {
        case 401:
          return UnauthorizedFailure(
            message: error.message,
            code: error.errorCode,
            cause: error,
          );
        case 404:
          return NotFoundFailure(
            message: error.message,
            code: error.errorCode,
            cause: error,
          );
        default:
          return UnknownFailure(
            message: error.message,
            code: error.errorCode,
            cause: error,
          );
      }
    }

    return UnknownFailure(
      message: error.message,
      cause: error,
    );
  }
}

final postsRepositoryProvider = Provider<IPostsRepository>((ref) {
  final dataSource = ref.watch(postsDataSourceProvider);
  return PostsRepository(dataSource: dataSource);
});

PostModel _mapJsonToPostModel(Map<String, dynamic> json) {
  return PostModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    userId: (json['userId'] as num?)?.toInt() ?? 0,
    title: (json['title'] as String? ?? '').trim(),
    body: (json['body'] as String? ?? '').trim(),
  );
}
