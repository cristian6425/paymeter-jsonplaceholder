class PostModel {
  const PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  })  : assert(id >= 0, 'id must be positive'),
        assert(userId >= 0, 'userId must be positive'),
        assert(title != '', 'title cannot be empty'),
        assert(body != '', 'body cannot be empty');

  final int id;
  final int userId;
  final String title;
  final String body;

  PostModel copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }
}
