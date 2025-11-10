class PaginatedQuery<T> {
  const PaginatedQuery({
    required this.items,
    this.nextStart,
    required this.hasMore,
    this.totalCount,
  });

  final List<T> items;
  final int? nextStart;
  final bool hasMore;
  final int? totalCount;

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  PaginatedQuery<T> copyWith({
    List<T>? items,
    int? nextStart,
    bool? hasMore,
    int? totalCount,
  }) {
    return PaginatedQuery<T>(
      items: items ?? this.items,
      nextStart: nextStart ?? this.nextStart,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  PaginatedQuery<R> map<R>(R Function(T item) transform) {
    return PaginatedQuery<R>(
      items: items.map(transform).toList(growable: false),
      nextStart: nextStart,
      hasMore: hasMore,
      totalCount: totalCount,
    );
  }
}
