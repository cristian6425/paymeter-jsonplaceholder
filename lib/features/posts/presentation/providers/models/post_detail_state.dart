import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';

part 'post_detail_state.freezed.dart';

class PostDetailArgs {
  const PostDetailArgs({
    required this.postId,
    this.cachedPost,
  }) : assert(postId > 0, 'postId must be positive');

  final int postId;
  final PostModel? cachedPost;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other.runtimeType == runtimeType &&
        other is PostDetailArgs &&
        other.postId == postId;
  }

  @override
  int get hashCode => postId.hashCode;
}

@freezed
class PostDetailState with _$PostDetailState {
  const factory PostDetailState({
    PostModel? post,
    @Default(false) bool isFromCache,
    @Default(true) bool isLoading,
  }) = _PostDetailState;

  const PostDetailState._();

  factory PostDetailState.initial() => const PostDetailState();
}
