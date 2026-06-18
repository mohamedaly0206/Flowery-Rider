import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouter {
  static GoRouter getRouter({
    String initialLocation = AppRouterPaths.kLoginView,
  }) => GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          AppLocalizations.of(context)!.errorMessage,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ),
    routes: [],
  );
}
