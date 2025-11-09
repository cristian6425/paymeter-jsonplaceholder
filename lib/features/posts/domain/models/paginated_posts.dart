import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';

class PaginatedPosts {
  const PaginatedPosts({
    required this.items,
    required this.nextStart,
    required this.hasMore,
  });

  final List<PostModel> items;
  final int nextStart;
  final bool hasMore;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  factory PaginatedPosts.empty() {
    return const PaginatedPosts(
      items: [],
      nextStart: 0,
      hasMore: false,
    );
  }

  PaginatedPosts copyWith({
    List<PostModel>? items,
    int? nextStart,
    bool? hasMore,
  }) {
    return PaginatedPosts(
      items: items ?? this.items,
      nextStart: nextStart ?? this.nextStart,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
