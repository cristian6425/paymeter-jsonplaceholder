// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'posts_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PostsListState {
  List<PostModel> get items => throw _privateConstructorUsedError;
  int get nextStart => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isPaginating => throw _privateConstructorUsedError;

  /// Create a copy of PostsListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostsListStateCopyWith<PostsListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostsListStateCopyWith<$Res> {
  factory $PostsListStateCopyWith(
    PostsListState value,
    $Res Function(PostsListState) then,
  ) = _$PostsListStateCopyWithImpl<$Res, PostsListState>;
  @useResult
  $Res call({
    List<PostModel> items,
    int nextStart,
    bool hasMore,
    bool isLoading,
    bool isPaginating,
  });
}

/// @nodoc
class _$PostsListStateCopyWithImpl<$Res, $Val extends PostsListState>
    implements $PostsListStateCopyWith<$Res> {
  _$PostsListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostsListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextStart = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isPaginating = null,
  }) {
    return _then(
      _value.copyWith(
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<PostModel>,
            nextStart: null == nextStart
                ? _value.nextStart
                : nextStart // ignore: cast_nullable_to_non_nullable
                      as int,
            hasMore: null == hasMore
                ? _value.hasMore
                : hasMore // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isPaginating: null == isPaginating
                ? _value.isPaginating
                : isPaginating // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PostsListStateImplCopyWith<$Res>
    implements $PostsListStateCopyWith<$Res> {
  factory _$$PostsListStateImplCopyWith(
    _$PostsListStateImpl value,
    $Res Function(_$PostsListStateImpl) then,
  ) = __$$PostsListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<PostModel> items,
    int nextStart,
    bool hasMore,
    bool isLoading,
    bool isPaginating,
  });
}

/// @nodoc
class __$$PostsListStateImplCopyWithImpl<$Res>
    extends _$PostsListStateCopyWithImpl<$Res, _$PostsListStateImpl>
    implements _$$PostsListStateImplCopyWith<$Res> {
  __$$PostsListStateImplCopyWithImpl(
    _$PostsListStateImpl _value,
    $Res Function(_$PostsListStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PostsListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextStart = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isPaginating = null,
  }) {
    return _then(
      _$PostsListStateImpl(
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<PostModel>,
        nextStart: null == nextStart
            ? _value.nextStart
            : nextStart // ignore: cast_nullable_to_non_nullable
                  as int,
        hasMore: null == hasMore
            ? _value.hasMore
            : hasMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isPaginating: null == isPaginating
            ? _value.isPaginating
            : isPaginating // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PostsListStateImpl extends _PostsListState {
  const _$PostsListStateImpl({
    final List<PostModel> items = const <PostModel>[],
    this.nextStart = 0,
    this.hasMore = true,
    this.isLoading = true,
    this.isPaginating = false,
  }) : _items = items,
       super._();

  final List<PostModel> _items;
  @override
  @JsonKey()
  List<PostModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final int nextStart;
  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isPaginating;

  @override
  String toString() {
    return 'PostsListState(items: $items, nextStart: $nextStart, hasMore: $hasMore, isLoading: $isLoading, isPaginating: $isPaginating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostsListStateImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextStart, nextStart) ||
                other.nextStart == nextStart) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isPaginating, isPaginating) ||
                other.isPaginating == isPaginating));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    nextStart,
    hasMore,
    isLoading,
    isPaginating,
  );

  /// Create a copy of PostsListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostsListStateImplCopyWith<_$PostsListStateImpl> get copyWith =>
      __$$PostsListStateImplCopyWithImpl<_$PostsListStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PostsListState extends PostsListState {
  const factory _PostsListState({
    final List<PostModel> items,
    final int nextStart,
    final bool hasMore,
    final bool isLoading,
    final bool isPaginating,
  }) = _$PostsListStateImpl;
  const _PostsListState._() : super._();

  @override
  List<PostModel> get items;
  @override
  int get nextStart;
  @override
  bool get hasMore;
  @override
  bool get isLoading;
  @override
  bool get isPaginating;

  /// Create a copy of PostsListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostsListStateImplCopyWith<_$PostsListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
