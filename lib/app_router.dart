import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/presentation/screens/splash_screen.dart';
import 'core/utils/constants.dart';

enum Routes {
  splash(routeName: 'splash', path: '/splash');

  final String routeName;
  final String path;

  const Routes({required this.routeName, required this.path});
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: Constants.navigatorKey,
    initialLocation: Routes.splash.path,
    routes: <RouteBase>[GoRoute(path: Routes.splash.path, name: Routes.splash.routeName, builder: (context, state) => const SplashScreen())],
  );
});
