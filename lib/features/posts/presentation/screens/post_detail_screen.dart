import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paymeterjsonplaceholder/app_router.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/primary_button.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/secondary_button.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/models/post_detail_state.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/post_detail_controller.dart';

class PostDetailScreen extends ConsumerWidget {
  const PostDetailScreen({
    super.key,
    required this.postId,
    this.cachedPost,
  });

  final int postId;
  final PostModel? cachedPost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (postId <= 0) {
      return const Scaffold(
        body: Center(child: Text('Identificador inválido.')),
      );
    }

    final provider = postDetailControllerProvider(
      PostDetailArgs(postId: postId, cachedPost: cachedPost),
    );
    final detailAsync = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post #$postId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: detailAsync.when(
          data: (state) {
            if (state.post == null && state.isLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (state.post == null) {
              return _PostDetailEmpty(onRetry: notifier.refresh);
            }

            return _PostDetailContent(
              post: state.post!,
              isFromCache: state.isFromCache,
              onEdit: () => _openEdit(context, state.post!.id),
              onRetry: notifier.refresh,
              isLoading: state.isLoading,
            );
          },
          error: (error, _) => _PostDetailError(
            message: error.toString(),
            onRetry: notifier.refresh,
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      ),
    );
  }

  void _openEdit(BuildContext context, int id) {
    context.pushNamed(
      Routes.postEdit.routeName,
      pathParameters: {'id': id.toString()},
    );
  }
}

class _PostDetailContent extends StatelessWidget {
  const _PostDetailContent({
    required this.post,
    required this.isFromCache,
    required this.onEdit,
    required this.onRetry,
    required this.isLoading,
  });

  final PostModel post;
  final bool isFromCache;
  final VoidCallback onEdit;
  final VoidCallback onRetry;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFromCache)
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.sync),
            label: const Text('Mostrando datos en caché, actualizar'),
          ),
        Text(
          post.title,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              post.body,
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(),
          ),
        PrimaryButton(
          label: 'Editar post',
          onPressed: onEdit,
        ),
      ],
    );
  }
}

class _PostDetailEmpty extends StatelessWidget {
  const _PostDetailEmpty({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No encontramos este post',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Puede que haya sido eliminado o no exista.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'Intentar nuevamente',
            onPressed: onRetry,
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}

class _PostDetailError extends StatelessWidget {
  const _PostDetailError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Algo salió mal',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          SecondaryButton(
            label: 'Reintentar',
            onPressed: onRetry,
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}
