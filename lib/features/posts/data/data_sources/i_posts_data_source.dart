abstract class IPostsDataSource {
  Future<List<Map<String, dynamic>>> fetchPosts({
    int start,
    int limit,
  });

  Future<Map<String, dynamic>> fetchPost(int id);
}
