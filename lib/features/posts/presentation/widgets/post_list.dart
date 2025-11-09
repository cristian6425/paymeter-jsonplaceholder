import 'package:flutter/material.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/widgets/post_card.dart';

class PostList extends StatefulWidget {
  const PostList({
    super.key,
    required this.posts,
    this.onPostSelected,
    this.onEndReached,
    this.isPaginating = false,
  });

  final List<PostModel> posts;
  final ValueChanged<PostModel>? onPostSelected;
  final VoidCallback? onEndReached;
  final bool isPaginating;

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late final ScrollController _controller;
  bool _hasPendingPagination = false;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PostList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isPaginating) {
      _hasPendingPagination = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.posts.length + (widget.isPaginating ? 1 : 0);
    return ListView.separated(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index >= widget.posts.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }

        final post = widget.posts[index];
        return PostCard(
          post: post,
          onTap: () => widget.onPostSelected?.call(post),
        );
      },
    );
  }

  void _onScroll() {
    if (!_controller.hasClients || widget.onEndReached == null) {
      return;
    }

    final position = _controller.position;
    if (position.maxScrollExtent <= 0 || _hasPendingPagination) {
      return;
    }

    final remaining = position.maxScrollExtent - position.pixels;
    if (remaining <= 240 && !position.outOfRange) {
      _hasPendingPagination = true;
      widget.onEndReached!.call();
    }
  }
}
