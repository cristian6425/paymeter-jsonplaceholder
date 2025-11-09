abstract class IPostsDataSource {
  Future<List<Map<String, dynamic>>> fetchPosts({
    int start,
    int limit,
  });

  Future<Map<String, dynamic>> fetchPost(int id);

  Future<Map<String, dynamic>> createPost(Map<String, dynamic> payload);
}
