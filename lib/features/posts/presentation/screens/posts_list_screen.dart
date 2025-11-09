import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/primary_button.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/secondary_button.dart';

class PostsListScreen extends StatelessWidget {
  const PostsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholders = List.generate(5, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PrimaryButton(
              label: 'Crear nuevo post',
              onPressed: () => context.push('/posts/new'),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Recargar',
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: placeholders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = placeholders[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        'Placeholder Post $item',
                        style: theme.textTheme.titleMedium,
                      ),
                      subtitle: const Text(
                        'Aquí se mostrará el resumen del post una vez que se conecte el endpoint.',
                      ),
                      onTap: () => context.push('/posts/$item'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
