import 'package:paymeterjsonplaceholder/features/posts/domain/models/value_objects/post_value_objects.dart';

class CreatePostParams {
  const CreatePostParams({
    required this.title,
    required this.body,
    this.userId = defaultUserId,
  });

  final PostTitle title;
  final PostBody body;
  final int userId;

  static const int defaultUserId = 1;

  Map<String, dynamic> toJson() {
    return {
      'title': title.value,
      'body': body.value,
      'userId': userId,
    };
  }
}
