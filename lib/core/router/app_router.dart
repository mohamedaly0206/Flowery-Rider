import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view/app_section_view.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view_model/cubit/app_section_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/login/view_model/cubit/login_cubit.dart';
import 'package:flowery_rider/features/auth/presentation/login/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    routes: [
      GoRoute(
        path: AppRouterPaths.kLoginView,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<LoginCubit>(),
          child: LoginView(),
        ),
      ),
      GoRoute(
        path: AppRouterPaths.kAppSections,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AppSectionCubit>(),
          child: const AppSectionView(),
        ),
      ),
    ],
  );
}
