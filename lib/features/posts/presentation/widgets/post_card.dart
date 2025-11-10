import 'package:flutter/material.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onEdit,
  });

  final PostModel post;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                post.body,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Autor: ${post.userId}',
                    style: theme.textTheme.labelMedium,
                  ),
                  const Spacer(),
                  if (onEdit != null)
                    TextButton(
                      onPressed: onEdit,
                      child: const Text('Editar'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
