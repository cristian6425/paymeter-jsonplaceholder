import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';

class PostTitle {
  const PostTitle._(this.value);

  final String value;

  static Result<PostTitle> create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return FailureResult(
        ValidationFailure(
          message: 'Title is required.',
          fieldErrors: {
            'title': ['Title is required.'],
          },
        ),
      );
    }
    return Success(PostTitle._(trimmed));
  }
}

class PostBody {
  const PostBody._(this.value);

  final String value;

  static const int minLength = 10;

  static Result<PostBody> create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length < minLength) {
      return FailureResult(
        ValidationFailure(
          message: 'Body must contain at least $minLength characters.',
          fieldErrors: {
            'body': ['Body must contain at least $minLength characters.'],
          },
        ),
      );
    }
    return Success(PostBody._(trimmed));
  }
}
