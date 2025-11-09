class PaginationParams {
  const PaginationParams({
    this.start = 0,
    this.limit = defaultLimit,
  })  : assert(start >= 0, 'start must be zero or positive'),
        assert(limit > 0 && limit <= maxLimit, 'limit must be between 1 and $maxLimit');

  static const int defaultLimit = 20;
  static const int maxLimit = 20;

  final int start;
  final int limit;

  PaginationParams copyWith({
    int? start,
    int? limit,
  }) {
    return PaginationParams(
      start: start ?? this.start,
      limit: limit ?? this.limit,
    );
  }

  PaginationParams nextPage(int consumedItems) {
    final nextStart = start + consumedItems;
    return PaginationParams(
      start: nextStart,
      limit: limit,
    );
  }

  PaginationParams sanitized() {
    final clampedLimit = limit > maxLimit ? maxLimit : limit;
    final clampedStart = start < 0 ? 0 : start;
    return PaginationParams(
      start: clampedStart,
      limit: clampedLimit,
    );
  }
}
