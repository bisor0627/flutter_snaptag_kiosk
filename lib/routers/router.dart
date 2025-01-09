import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snaptag_kiosk/lib.dart';
import 'package:go_router/go_router.dart';
import 'package:material_components/material_components.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.admin.dart';
part 'router.g.dart';
part 'router.kiosk.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/payment-request-test',
    routes: $appRoutes,
    observers: <NavigatorObserver>[NavObserver()],
  );
}

@TypedGoRoute<SplashRoute>(
  path: '/splash',
)
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}
