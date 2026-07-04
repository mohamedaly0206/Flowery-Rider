import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/features/profile/my_profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/edit_my_info/view_model/cubit/edit_profile_cubit.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/edit_my_info/views/edit_my_info_view.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/view_model/cubit/profile_cubit.dart';
import 'package:flowery_rider/features/profile/my_profile/presentation/profile/views/profile_view.dart';
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
        path: AppRouterPaths.kProfileView,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ProfileCubit>(),
          child: const ProfileView(),
        ),
      ),
      GoRoute(
        path: AppRouterPaths.kEditProfileView,
        builder: (context, state) {
          final driverEntity = state.extra as DriverProfileEntity;
          return BlocProvider(
            create: (context) => getIt<EditProfileCubit>(),
            child: EditMyInfoView(driver: driverEntity),
          );
        },
      ),
    ],
  );
}
