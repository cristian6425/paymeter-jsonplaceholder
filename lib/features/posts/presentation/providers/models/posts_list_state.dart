import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';

part 'posts_list_state.freezed.dart';

@freezed
class PostsListState with _$PostsListState {
  const factory PostsListState({
    @Default(<PostModel>[]) List<PostModel> items,
    @Default(0) int nextStart,
    @Default(true) bool hasMore,
    @Default(true) bool isLoading,
    @Default(false) bool isPaginating,
  }) = _PostsListState;

  const PostsListState._();

  factory PostsListState.initial() => const PostsListState();

  bool get isEmpty => items.isEmpty;
}
