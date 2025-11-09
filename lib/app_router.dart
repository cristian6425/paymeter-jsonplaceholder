import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:paymeterjsonplaceholder/features/posts/domain/models/post_model.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/screens/post_detail_screen.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/screens/post_form_screen.dart';
import 'package:paymeterjsonplaceholder/features/posts/presentation/screens/posts_list_screen.dart';

import 'core/presentation/screens/splash_screen.dart';
import 'core/utils/constants.dart';

enum Routes {
  splash(routeName: 'splash', path: '/splash'),
  posts(routeName: 'posts', path: '/posts'),
  postCreate(routeName: 'post-create', path: '/posts/new'),
  postDetail(routeName: 'post-detail', path: '/posts/:id'),
  postEdit(routeName: 'post-edit', path: '/posts/:id/edit');

  final String routeName;
  final String path;

  const Routes({required this.routeName, required this.path});
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: Constants.navigatorKey,
    initialLocation: Routes.posts.path,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.posts.path,
        name: Routes.posts.routeName,
        builder: (context, state) => const PostsListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            name: Routes.postCreate.routeName,
            builder: (context, state) => const PostFormScreen(mode: PostFormMode.create),
          ),
          GoRoute(
            path: ':id',
            name: Routes.postDetail.routeName,
            builder: (context, state) {
              final rawId = state.pathParameters['id'];
              final postId = rawId != null ? int.tryParse(rawId) ?? 0 : 0;
              final cachedPost =
                  state.extra is PostModel ? state.extra as PostModel : null;
              return PostDetailScreen(
                postId: postId,
                cachedPost: cachedPost,
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: Routes.postEdit.routeName,
                builder: (context, state) => PostFormScreen(
                  mode: PostFormMode.edit,
                  postId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
