// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postDetailControllerHash() =>
    r'b96aedf42447e1ac589958c5bcc97abb1ac06069';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PostDetailController
    extends BuildlessAutoDisposeAsyncNotifier<PostDetailState> {
  late final PostDetailArgs args;

  FutureOr<PostDetailState> build(PostDetailArgs args);
}

/// See also [PostDetailController].
@ProviderFor(PostDetailController)
const postDetailControllerProvider = PostDetailControllerFamily();

/// See also [PostDetailController].
class PostDetailControllerFamily extends Family<AsyncValue<PostDetailState>> {
  /// See also [PostDetailController].
  const PostDetailControllerFamily();

  /// See also [PostDetailController].
  PostDetailControllerProvider call(PostDetailArgs args) {
    return PostDetailControllerProvider(args);
  }

  @override
  PostDetailControllerProvider getProviderOverride(
    covariant PostDetailControllerProvider provider,
  ) {
    return call(provider.args);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postDetailControllerProvider';
}

/// See also [PostDetailController].
class PostDetailControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PostDetailController,
          PostDetailState
        > {
  /// See also [PostDetailController].
  PostDetailControllerProvider(PostDetailArgs args)
    : this._internal(
        () => PostDetailController()..args = args,
        from: postDetailControllerProvider,
        name: r'postDetailControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$postDetailControllerHash,
        dependencies: PostDetailControllerFamily._dependencies,
        allTransitiveDependencies:
            PostDetailControllerFamily._allTransitiveDependencies,
        args: args,
      );

  PostDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.args,
  }) : super.internal();

  final PostDetailArgs args;

  @override
  FutureOr<PostDetailState> runNotifierBuild(
    covariant PostDetailController notifier,
  ) {
    return notifier.build(args);
  }

  @override
  Override overrideWith(PostDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PostDetailControllerProvider._internal(
        () => create()..args = args,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        args: args,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<PostDetailController, PostDetailState>
  createElement() {
    return _PostDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PostDetailControllerProvider && other.args == args;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, args.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PostDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PostDetailState> {
  /// The parameter `args` of this provider.
  PostDetailArgs get args;
}

class _PostDetailControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PostDetailController,
          PostDetailState
        >
    with PostDetailControllerRef {
  _PostDetailControllerProviderElement(super.provider);

  @override
  PostDetailArgs get args => (origin as PostDetailControllerProvider).args;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
