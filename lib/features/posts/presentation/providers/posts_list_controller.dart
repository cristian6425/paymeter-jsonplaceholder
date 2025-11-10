import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/application/use_cases/fetch_posts_use_case.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/paginated_posts.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/pagination_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/posts_list_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'posts_list_controller.g.dart';

@riverpod
class PostsListController extends _$PostsListController {
  FetchPostsUseCase get _fetchPostsUseCase =>
      ref.read(fetchPostsUseCaseProvider);

  @override
  FutureOr<PostsListState> build() {
    ref.keepAlive();
    Future.microtask(_loadInitialPage);
    return PostsListState.initial();
  }

  Future<void> refresh() async {
    await _loadInitialPage();
  }

  Future<void> loadNextPage() async {
    final snapshot = state.valueOrNull;
    if (snapshot == null || snapshot.isPaginating || !snapshot.hasMore) {
      return;
    }

    _setState(snapshot.copyWith(isPaginating: true));

    final result = await _fetchPage(start: snapshot.nextStart);

    result.when(
      success: (page) {
        final updated = snapshot.copyWith(
          items: [...snapshot.items, ...page.items],
          nextStart: page.nextStart,
          hasMore: page.hasMore,
          isLoading: false,
          isPaginating: false,
        );
        _setState(updated);
      },
      failure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  Future<void> _loadInitialPage() async {
    _setState(PostsListState.initial());

    final result = await _fetchPage(start: 0);

    result.when(
      success: (page) {
        _setState(
          PostsListState(
            items: page.items,
            nextStart: page.nextStart,
            hasMore: page.hasMore,
            isLoading: false,
            isPaginating: false,
          ),
        );
      },
      failure: (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
    );
  }

  Future<Result<PaginatedPosts>> _fetchPage({required int start}) {
    return _fetchPostsUseCase(
      PaginationParams(start: start),
    );
  }

  void _setState(PostsListState newState) {
    state = AsyncValue.data(newState);
  }

  void upsertPost(PostModel post) {
    final snapshot = state.valueOrNull;
    if (snapshot == null) {
      _setState(
        PostsListState(
          items: [post],
          nextStart: 0,
          hasMore: true,
          isLoading: false,
          isPaginating: false,
        ),
      );
      return;
    }

    final existingIndex =
        snapshot.items.indexWhere((element) => element.id == post.id);

    if (existingIndex == -1) {
      final updatedItems = [post, ...snapshot.items];
      _setState(snapshot.copyWith(items: updatedItems));
    } else {
      final updatedItems = [...snapshot.items];
      updatedItems[existingIndex] = post;
      _setState(snapshot.copyWith(items: updatedItems));
    }
  }

  void removePost(int id) {
    final snapshot = state.valueOrNull;
    if (snapshot == null) {
      return;
    }

    final updatedItems =
        snapshot.items.where((element) => element.id != id).toList();
    _setState(snapshot.copyWith(items: updatedItems));
  }
}
