import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/features/posts/application/use_cases/patch_post_use_case.dart';
import 'package:paymeterjsonplaceholder/features/posts/application/use_cases/update_post_use_case.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/create_post_form_controller.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/create_post_form_state.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/post_detail_state.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/post_detail_controller.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/posts_list_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_post_form_controller.g.dart';

class EditPostFormArgs {
  const EditPostFormArgs({required this.post});

  final PostModel post;
}

@riverpod
class EditPostFormController extends _$EditPostFormController {
  UpdatePostUseCase get _updateUseCase =>
      ref.read(updatePostUseCaseProvider);
  PatchPostUseCase get _patchUseCase =>
      ref.read(patchPostUseCaseProvider);

  late EditPostFormArgs args;
  late String _initialTitle;
  late String _initialBody;

  @override
  FutureOr<CreatePostFormState> build(EditPostFormArgs args) {
    ref.keepAlive();
    this.args = args;
    _initialTitle = args.post.title;
    _initialBody = args.post.body;
    return CreatePostFormState(
      title: args.post.title,
      body: args.post.body,
      userId: args.post.userId,
    );
  }

  void onTitleChanged(String value) {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    _setState(
      snapshot.copyWith(
        title: value,
        titleError: null,
        generalError: null,
      ),
    );
  }

  void onBodyChanged(String value) {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    _setState(
      snapshot.copyWith(
        body: value,
        bodyError: null,
        generalError: null,
      ),
    );
  }

  bool get hasUnsavedChanges {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    return snapshot.title.trim() != _initialTitle ||
        snapshot.body.trim() != _initialBody;
  }

  Future<void> saveFull() async {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    if (snapshot.isSubmitting || !snapshot.canSubmit) {
      return;
    }

    _setState(snapshot.copyWith(isSubmitting: true, generalError: null));

    final result = await _updateUseCase(
      UpdatePostInput(
        id: args.post.id,
        title: snapshot.title,
        body: snapshot.body,
        userId: snapshot.userId,
      ),
    );

    result.when(
      success: _handleSuccess,
      failure: _handleFailure,
    );
  }

  Future<void> savePartial() async {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    if (snapshot.isSubmitting) {
      return;
    }

    final trimmedTitle = snapshot.title.trim();
    final trimmedBody = snapshot.body.trim();
    final titleChanged =
        trimmedTitle.isNotEmpty && trimmedTitle != _initialTitle;
    final bodyChanged =
        trimmedBody.isNotEmpty && trimmedBody != _initialBody;

    if (!titleChanged && !bodyChanged) {
      _setState(
        snapshot.copyWith(
          generalError: 'No changes to save.',
        ),
      );
      return;
    }

    _setState(snapshot.copyWith(isSubmitting: true, generalError: null));

    final result = await _patchUseCase(
      PatchPostInput(
        id: args.post.id,
        title: titleChanged ? trimmedTitle : null,
        body: bodyChanged ? trimmedBody : null,
      ),
    );

    result.when(
      success: _handleSuccess,
      failure: _handleFailure,
    );
  }

  void _handleSuccess(PostModel post) {
    _initialTitle = post.title;
    _initialBody = post.body;
    ref.read(postsListControllerProvider.notifier).upsertPost(post);
    ref
        .read(
          postDetailControllerProvider(
            PostDetailArgs(postId: post.id, cachedPost: post),
          ).notifier,
        )
        .applyExternalUpdate(post);

    _setState(
      CreatePostFormState(
        title: post.title,
        body: post.body,
        createdPost: post,
        userId: post.userId,
        isSubmitting: false,
      ),
    );
  }

  void _handleFailure(Failure failure) {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    if (failure is ValidationFailure) {
      _setState(
        snapshot.copyWith(
          isSubmitting: false,
          titleError: failure.fieldErrors['title']?.first,
          bodyError: failure.fieldErrors['body']?.first,
          generalError: failure.message,
        ),
      );
      return;
    }

    _setState(
      snapshot.copyWith(
        isSubmitting: false,
        generalError: failure.message,
      ),
    );
  }

  void _setState(CreatePostFormState newState) {
    state = AsyncValue.data(newState);
  }
}
