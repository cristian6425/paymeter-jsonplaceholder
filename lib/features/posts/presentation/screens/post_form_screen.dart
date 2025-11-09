import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/app_text_field.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/primary_button.dart';
import 'package:paymeterjsonplaceholder/core/presentation/widgets/secondary_button.dart';

enum PostFormMode { create, edit }

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({
    super.key,
    required this.mode,
    this.postId,
  });

  final PostFormMode mode;
  final String? postId;

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
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
    final isEditing = widget.mode == PostFormMode.edit;
    final title = isEditing ? 'Editar post' : 'Nuevo post';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _titleController,
                label: 'Título',
                hintText: 'Ingresa el título del post',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _bodyController,
                label: 'Contenido',
                hintText: 'Describe el contenido principal',
                maxLines: 5,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                label: isEditing ? 'Actualizar post' : 'Guardar post',
                onPressed: _onSubmit,
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Cancelar',
                onPressed: () => context.pop(),
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

    final message = widget.mode == PostFormMode.edit
        ? 'Post actualizado (placeholder)'
        : 'Post creado (placeholder)';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    context.pop();
  }
}
