import 'dart:async';

import 'package:paymeterjsonplaceholder/features/posts/application/use_cases/fetch_post_detail_use_case.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/post_detail_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_detail_controller.g.dart';

@riverpod
class PostDetailController extends _$PostDetailController {
  FetchPostDetailUseCase get _useCase =>
      ref.read(fetchPostDetailUseCaseProvider);

  late PostDetailArgs _args;

  @override
  FutureOr<PostDetailState> build(PostDetailArgs args) {
    _args = args;
    Future.microtask(_fetchFresh);
    return PostDetailState.initial();
  }

  Future<void> refresh() async {
    await _fetchFresh();
  }

  Future<void> _fetchFresh() async {
    final snapshot = state.valueOrNull ?? PostDetailState.initial();
    _setState(snapshot.copyWith(isLoading: true));

    final result = await _useCase(
      FetchPostDetailParams(_args.postId),
    );

    result.when(
      success: (post) {
        _setState(
          PostDetailState(
            post: post,
            isLoading: false,
          ),
        );
      },
      failure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  void _setState(PostDetailState newState) {
    state = AsyncValue.data(newState);
  }

  void applyExternalUpdate(PostModel post) {
    _setState(
      PostDetailState(
        post: post,
        isLoading: false,
      ),
    );
  }

  void removeCurrentPost() {
    state = AsyncValue.data(
      PostDetailState(
        post: null,
        isLoading: false,
      ),
    );
  }
}
