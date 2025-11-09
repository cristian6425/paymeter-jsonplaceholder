import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/primary_button.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle #$postId'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Título pendiente',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Aquí se mostrará el contenido completo del post seleccionado. '
              'Una vez implementada la capa de datos, esta pantalla se '
              'alimentará del repositorio correspondiente.',
              style: theme.textTheme.bodyLarge,
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Editar post',
              onPressed: () => context.push('/posts/$postId/edit'),
            ),
          ],
        ),
      ),
    );
  }
}
