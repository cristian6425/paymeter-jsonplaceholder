import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/create_post_params.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/value_objects/post_value_objects.dart';

part 'create_post_form_state.freezed.dart';

@freezed
class CreatePostFormState with _$CreatePostFormState {
  const factory CreatePostFormState({
    @Default('') String title,
    @Default('') String body,
    String? titleError,
    String? bodyError,
    String? generalError,
    @Default(false) bool isSubmitting,
    PostModel? createdPost,
    @Default(CreatePostParams.defaultUserId) int userId,
  }) = _CreatePostFormState;

  const CreatePostFormState._();

  factory CreatePostFormState.initial() => const CreatePostFormState();

  bool get canSubmit =>
      title.trim().isNotEmpty && body.trim().length >= PostBody.minLength && !isSubmitting;
}
