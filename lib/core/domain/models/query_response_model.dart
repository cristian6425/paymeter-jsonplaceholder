class QueryResponseModel<T> {
  const QueryResponseModel({
    this.data,
    this.message,
    this.isSuccessful = true,
  });

  final T? data;
  final String? message;
  final bool isSuccessful;

  QueryResponseModel<T> copyWith({
    T? data,
    String? message,
    bool? isSuccessful,
  }) {
    return QueryResponseModel<T>(
      data: data ?? this.data,
      message: message ?? this.message,
      isSuccessful: isSuccessful ?? this.isSuccessful,
    );
  }
}
