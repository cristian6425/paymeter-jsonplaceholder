import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paymeterjsonplaceholder/app_router.dart';
import 'package:paymeterjsonplaceholder/core/presentation/themes/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'JsonPlaceholder Clean Architecture',
      theme: AppThemes.light(),
      routerConfig: router,
    );
  }
}
