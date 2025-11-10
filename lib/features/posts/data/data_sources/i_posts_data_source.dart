abstract class IPostsDataSource {
  Future<List<Map<String, dynamic>>> fetchPosts({
    int start,
    int limit,
  });

  Future<Map<String, dynamic>> fetchPost(int id);

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> payload);

  Future<Map<String, dynamic>> updatePost({
    required int id,
    required Map<String, dynamic> payload,
  });

  Future<Map<String, dynamic>> patchPost({
    required int id,
    required Map<String, dynamic> payload,
  });

  Future<void> deletePost(int id);
}
