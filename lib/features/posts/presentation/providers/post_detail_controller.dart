import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
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
    ref.keepAlive();
    _args = args;

    if (args.cachedPost != null) {
      final cachedState = PostDetailState(
        post: args.cachedPost,
        isFromCache: true,
        isLoading: true,
      );
      Future.microtask(_fetchFresh);
      return cachedState;
    }

    Future.microtask(_fetchFresh);
    return PostDetailState.initial();
  }

  Future<void> refresh() async {
    await _fetchFresh();
  }

  Future<void> _fetchFresh() async {
    final snapshot = state.valueOrNull ?? PostDetailState.initial();
    _setState(snapshot.copyWith(isLoading: true, isFromCache: false));

    final result = await _useCase(
      FetchPostDetailParams(_args.postId),
    );

    result.when(
      success: (post) {
        _setState(
          PostDetailState(
            post: post,
            isFromCache: false,
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
        isFromCache: false,
        isLoading: false,
      ),
    );
  }
}
