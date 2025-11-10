import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/data/errors/data_error.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/data_sources/i_posts_data_source.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/data_sources/posts_api_data_source.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/create_post_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/paginated_posts.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/pagination_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/update_post_params.dart';
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
          message: 'Unable to load the posts list.',
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
          message: 'Unable to fetch the post details.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncResult<PostModel> createPost(CreatePostParams params) async {
    try {
      final json = await _dataSource.createPost(params.toJson());
      final post = _mapJsonToPostModel(json);
      return Success(post);
    } on DataError catch (error) {
      return FailureResult(_mapDataErrorToFailure(error));
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Unable to create the post.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncResult<PostModel> updatePost(UpdatePostParams params) async {
    try {
      final json = await _dataSource.updatePost(
        id: params.id,
        payload: params.toJson(),
      );
      final post = _mapJsonToPostModel(json);
      return Success(post);
    } on DataError catch (error) {
      return FailureResult(_mapDataErrorToFailure(error));
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Unable to update the post.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncResult<PostModel> patchPost(PatchPostParams params) async {
    try {
      final json = await _dataSource.patchPost(
        id: params.id,
        payload: params.toJson(),
      );
      final post = _mapJsonToPostModel(json);
      return Success(post);
    } on DataError catch (error) {
      return FailureResult(_mapDataErrorToFailure(error));
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Unable to update the post.',
          cause: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  AsyncResult<void> deletePost(int id) async {
    if (id <= 0) {
      return FailureResult(
        ValidationFailure(message: 'Invalid identifier.'),
      );
    }

    try {
      await _dataSource.deletePost(id);
      return const Success(null);
    } on DataError catch (error) {
      return FailureResult(_mapDataErrorToFailure(error));
    } catch (error, stackTrace) {
      return FailureResult(
        UnknownFailure(
          message: 'Unable to delete the post.',
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
        case 400:
        case 422:
          return ValidationFailure(
            message: error.message,
            code: error.errorCode,
            cause: error,
            fieldErrors: _extractFieldErrors(error),
          );
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

Map<String, List<String>> _extractFieldErrors(ApiError error) {
  final details = error.details;
  if (details == null) {
    return {};
  }

  final Map<String, List<String>> normalized = {};
  details.forEach((key, value) {
    if (value is List) {
      normalized[key] = value.map((e) => e.toString()).toList();
    } else if (value is String) {
      normalized[key] = [value];
    } else if (value != null) {
      normalized[key] = [value.toString()];
    }
  });

  if (normalized.isEmpty) {
    normalized['general'] = [error.message];
  }

  return normalized;
}
