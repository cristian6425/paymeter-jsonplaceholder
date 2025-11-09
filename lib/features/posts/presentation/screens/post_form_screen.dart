import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/app_text_field.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/primary_button.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/secondary_button.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/create_post_form_controller.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/create_post_form_state.dart';

enum PostFormMode { create, edit }

class PostFormScreen extends StatelessWidget {
  const PostFormScreen({
    super.key,
    required this.mode,
    this.postId,
  });

  final PostFormMode mode;
  final String? postId;

  @override
  Widget build(BuildContext context) {
    return mode == PostFormMode.create
        ? const _CreatePostFormView()
        : _EditPostFormPlaceholder(postId: postId);
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
              onPressed: formState.canSubmit ? notifier.submit : null,
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

class _EditPostFormPlaceholder extends StatefulWidget {
  const _EditPostFormPlaceholder({
    required this.postId,
  });

  final String? postId;

  @override
  State<_EditPostFormPlaceholder> createState() => _EditPostFormPlaceholderState();
}

class _EditPostFormPlaceholderState extends State<_EditPostFormPlaceholder> {
  final _formKey = GlobalKey<FormState>();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit post ${widget.postId ?? ''}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Title',
                hintText: 'Enter the post title',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _bodyController,
                label: 'Body',
                hintText: 'Post content',
                maxLines: 5,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required field' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: 'Update post',
                onPressed: _onSubmit,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post updated (placeholder)')),
    );
    Navigator.of(context).pop();
  }
}
