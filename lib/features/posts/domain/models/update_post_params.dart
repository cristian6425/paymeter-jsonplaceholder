import 'package:paymeterjsonplaceholder/features/posts/domain/models/value_objects/post_value_objects.dart';

class UpdatePostParams {
  const UpdatePostParams({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  }) : assert(id > 0, 'id must be positive');

  final int id;
  final PostTitle title;
  final PostBody body;
  final int userId;

  Map<String, dynamic> toJson() {
    return {
      'title': title.value,
      'body': body.value,
      'userId': userId,
    };
  }
}

class PatchPostParams {
  PatchPostParams({
    required this.id,
    this.title,
    this.body,
    this.userId,
  })  : assert(id > 0, 'id must be positive'),
        assert(
          title != null || body != null || userId != null,
          'At least one field must be provided',
        );

  final int id;
  final PostTitle? title;
  final PostBody? body;
  final int? userId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (title != null) {
      json['title'] = title!.value;
    }
    if (body != null) {
      json['body'] = body!.value;
    }
    if (userId != null) {
      json['userId'] = userId;
    }
    return json;
  }
}
