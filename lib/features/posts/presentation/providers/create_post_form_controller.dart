import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/failure.dart';
import 'package:paymeterjsonplaceholder/core/domain/models/result.dart';
import 'package:paymeterjsonplaceholder/features/posts/application/use_cases/create_post_use_case.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/create_post_form_state.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/posts_list_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_post_form_controller.g.dart';

@riverpod
class CreatePostFormController extends _$CreatePostFormController {
  CreatePostUseCase get _useCase => ref.read(createPostUseCaseProvider);

  @override
  FutureOr<CreatePostFormState> build() {
    return CreatePostFormState.initial();
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

  Future<void> submit() async {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    if (snapshot.isSubmitting || !snapshot.canSubmit) {
      return;
    }

    _setState(
      snapshot.copyWith(
        isSubmitting: true,
        titleError: null,
        bodyError: null,
        generalError: null,
        createdPost: null,
      ),
    );

    final result = await _useCase(
      CreatePostInput(
        title: snapshot.title,
        body: snapshot.body,
        userId: snapshot.userId,
      ),
    );

    result.when(
      success: (post) {
        ref.read(postsListControllerProvider.notifier).upsertPost(post);
        _setState(
          snapshot.copyWith(
            title: '',
            body: '',
            isSubmitting: false,
            createdPost: post,
            titleError: null,
            bodyError: null,
            generalError: null,
          ),
        );
      },
      failure: (failure) {
        _handleFailure(failure);
      },
    );
  }

  void resetForm() {
    _setState(CreatePostFormState.initial());
  }

  void _handleFailure(Failure failure) {
    final snapshot = state.valueOrNull ?? CreatePostFormState.initial();
    if (failure is ValidationFailure) {
      final titleError = failure.fieldErrors['title']?.first;
      final bodyError = failure.fieldErrors['body']?.first;
      final generalError =
          failure.fieldErrors['general']?.first ?? failure.message;

      _setState(
        snapshot.copyWith(
          isSubmitting: false,
          titleError: titleError,
          bodyError: bodyError,
          generalError: generalError,
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
