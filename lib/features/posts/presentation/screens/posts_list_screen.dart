import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paymeterjsonplaceholder/app_router.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/primary_button.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/secondary_button.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/providers/posts_list_controller.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/widgets/post_list.dart';

class PostsListScreen extends ConsumerWidget {
  const PostsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsListControllerProvider);
    final notifier = ref.read(postsListControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PrimaryButton(
              label: 'Create new post',
              onPressed: () => context.pushNamed(Routes.postCreate.routeName),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Refresh',
              onPressed: () {
                notifier.refresh();
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: postsAsync.when(
                data: (state) {
                  if (state.isEmpty && state.isLoading) {
                    return const _PostsListLoading();
                  }

                  if (state.isEmpty) {
                    return const _PostsListEmpty();
                  }

                  return RefreshIndicator(
                    onRefresh: notifier.refresh,
                    child: PostList(
                      posts: state.items,
                      isPaginating: state.isPaginating,
                      onPostSelected: (post) => _openDetail(context, post),
                      onEndReached: notifier.loadNextPage,
                    ),
                  );
                },
                error: (error, _) => _PostsListError(
                  onRetry: () {
                    notifier.refresh();
                  },
                  message: error.toString(),
                ),
                loading: () => const _PostsListLoading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, PostModel post) {
    context.pushNamed(
      Routes.postDetail.routeName,
      pathParameters: {'id': post.id.toString()},
    );
  }
}

class _PostsListLoading extends StatelessWidget {
  const _PostsListLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class _PostsListEmpty extends StatelessWidget {
  const _PostsListEmpty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No hay posts disponibles',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Create a new post or refresh to try again.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _PostsListError extends StatelessWidget {
  const _PostsListError({
    required this.onRetry,
    required this.message,
  });

  final VoidCallback onRetry;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: 56,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
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
            label: 'Intentar de nuevo',
            onPressed: onRetry,
            isExpanded: false,
          ),
        ],
      ),
    );
  }
}
