import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/app_text_field.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/primary_button.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/secondary_button.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/create_post_form_controller.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/edit_post_form_controller.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/create_post_form_state.dart';

enum PostFormMode { create, edit }

class PostFormScreen extends StatelessWidget {
  const PostFormScreen({
    super.key,
    required this.mode,
    this.postId,
    this.initialPost,
  });

  final PostFormMode mode;
  final int? postId;
  final PostModel? initialPost;

  @override
  Widget build(BuildContext context) {
    return mode == PostFormMode.create
        ? const _CreatePostFormView()
        : (postId != null && initialPost != null)
            ? _EditPostFormView(
                postId: postId!,
                initialPost: initialPost!,
              )
            : const _InvalidEditScreen();
  }
}

class _CreatePostFormView extends ConsumerStatefulWidget {
  const _CreatePostFormView();

  @override
  ConsumerState<_CreatePostFormView> createState() => _CreatePostFormViewState();
}

class _CreatePostFormViewState extends ConsumerState<_CreatePostFormView> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(createPostFormControllerProvider, (previous, next) {
      final prevState = previous?.valueOrNull;
      final currentState = next.valueOrNull;
      if (currentState == null) return;

      if (currentState.createdPost != null &&
          prevState?.createdPost != currentState.createdPost) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully.')),
        );
        Navigator.of(context).pop();
        ref.read(createPostFormControllerProvider.notifier).resetForm();
        _titleController.clear();
        _bodyController.clear();
      }
    });

    final formAsync = ref.watch(createPostFormControllerProvider);
    final formState = formAsync.value ?? CreatePostFormState.initial();
    final notifier = ref.read(createPostFormControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (formState.isSubmitting) const LinearProgressIndicator(),
            const SizedBox(height: 16),
            AppTextField(
              controller: _titleController,
              label: 'Title',
              hintText: 'Enter the post title',
              errorText: formState.titleError,
              onChanged: notifier.onTitleChanged,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _bodyController,
              label: 'Body',
              hintText: 'Write at least 10 characters',
              maxLines: 5,
              errorText: formState.bodyError,
              onChanged: notifier.onBodyChanged,
            ),
            if (formState.generalError != null) ...[
              const SizedBox(height: 12),
              Text(
                formState.generalError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Save post',
              onPressed: formState.canSubmit
                  ? () {
                      notifier.submit();
                    }
                  : null,
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Cancel',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditPostFormView extends ConsumerStatefulWidget {
  const _EditPostFormView({
    required this.postId,
    required this.initialPost,
  });

  final int postId;
  final PostModel initialPost;

  @override
  ConsumerState<_EditPostFormView> createState() => _EditPostFormViewState();
}

class _EditPostFormViewState extends ConsumerState<_EditPostFormView> {
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final EditPostFormArgs _args;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialPost.title);
    _bodyController = TextEditingController(text: widget.initialPost.body);
    _args = EditPostFormArgs(post: widget.initialPost);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = editPostFormControllerProvider(_args);
    ref.listen(provider, (previous, next) {
      final prevState = previous?.valueOrNull;
      final currentState = next.valueOrNull;
      if (currentState == null) return;

      if (prevState?.createdPost != currentState.createdPost &&
          currentState.createdPost != null &&
          !currentState.isSubmitting) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated successfully.')),
        );
        Navigator.of(context).pop();
      }
    });

    final formAsync = ref.watch(provider);
    final formState = formAsync.value ??
        CreatePostFormState(
          title: widget.initialPost.title,
          body: widget.initialPost.body,
          userId: widget.initialPost.userId,
        );
    final notifier = ref.read(provider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (formState.isSubmitting || !notifier.hasUnsavedChanges) {
          return true;
        }
        final shouldLeave = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Discard changes?'),
                content: const Text(
                  'You have unsaved changes. Are you sure you want to leave?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            ) ??
            false;
        return shouldLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit post #${widget.postId}'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (formState.isSubmitting) const LinearProgressIndicator(),
              const SizedBox(height: 16),
              AppTextField(
                controller: _titleController,
                label: 'Title',
                hintText: 'Enter the post title',
                errorText: formState.titleError,
                enabled: !formState.isSubmitting,
                onChanged: notifier.onTitleChanged,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _bodyController,
                label: 'Body',
                hintText: 'Update the content',
                maxLines: 5,
                errorText: formState.bodyError,
                enabled: !formState.isSubmitting,
                onChanged: notifier.onBodyChanged,
              ),
              if (formState.generalError != null) ...[
                const SizedBox(height: 12),
                Text(
                  formState.generalError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Save changes (PUT)',
                onPressed: formState.canSubmit
                    ? () {
                        notifier.saveFull();
                      }
                    : null,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Save changes (PATCH)',
                onPressed: formState.isSubmitting
                    ? null
                    : () {
                        notifier.savePartial();
                      },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed:
                    formState.isSubmitting ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvalidEditScreen extends StatelessWidget {
  const _InvalidEditScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Missing post information for editing.'),
      ),
    );
  }
}
