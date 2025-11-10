import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/data/errors/data_error.dart';
import 'package:paymeterjsonplaceholder/core/data/services/dio_http_client_service.dart';
import 'package:paymeterjsonplaceholder/features/posts/data/data_sources/i_posts_data_source.dart';

class PostsApiDataSource implements IPostsDataSource {
  PostsApiDataSource({
    required Dio client,
    this.resourcePath = '/posts',
  }) : _client = client;

  final Dio _client;
  final String resourcePath;

  @override
  Future<List<Map<String, dynamic>>> fetchPosts({
    int start = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _client.get<List<dynamic>>(
        resourcePath,
        queryParameters: <String, dynamic>{
          '_start': start,
          '_limit': limit,
        },
      );
      final data = response.data ?? const [];
      return data
          .map(
            (dynamic raw) => Map<String, dynamic>.from(raw as Map),
          )
          .toList(growable: false);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  @override
  Future<Map<String, dynamic>> fetchPost(int id) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        '$resourcePath/$id',
      );
      final data = response.data ?? const <String, dynamic>{};
      return Map<String, dynamic>.from(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  @override
  Future<Map<String, dynamic>> createPost(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await _client.post<Map<String, dynamic>>(
        resourcePath,
        data: payload,
      );
      final data = response.data ?? payload;
      return Map<String, dynamic>.from(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  @override
  Future<Map<String, dynamic>> updatePost({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _client.put<Map<String, dynamic>>(
        '$resourcePath/$id',
        data: payload,
      );
      final data = response.data ?? payload;
      return Map<String, dynamic>.from(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  @override
  Future<Map<String, dynamic>> patchPost({
    required int id,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _client.patch<Map<String, dynamic>>(
        '$resourcePath/$id',
        data: payload,
      );
      final data = response.data ?? payload;
      return Map<String, dynamic>.from(data);
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  @override
  Future<void> deletePost(int id) async {
    try {
      await _client.delete<void>('$resourcePath/$id');
    } on DioException catch (error) {
      throw _mapDioException(error);
    }
  }

  DataError _mapDioException(DioException error) {
    final underlying = error.error;
    if (underlying is DataError) {
      return underlying;
    }
    return ApiError(
      message: error.message ?? 'Error desconocido al acceder a posts.',
      statusCode: error.response?.statusCode,
    );
  }
}

final postsDataSourceProvider = Provider<IPostsDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return PostsApiDataSource(client: dio);
});
