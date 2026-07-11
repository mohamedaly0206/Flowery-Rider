import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/modules/auth/presentation/apply/view_model/cubit/apply_cubit.dart';
import 'package:flowery_rider/modules/auth/presentation/apply/views/apply_success_view.dart';
import 'package:flowery_rider/modules/auth/presentation/apply/views/apply_view.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/cubit/home_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/intent/home_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/views/home_view.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/map_route_args.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/map/view_model/cubit/map_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/map/view_model/intent/map_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/map/views/map_view.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/view_model/cubit/order_details_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/views/order_details_view.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_details/views/order_success_view.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view/app_section_view.dart';
import 'package:flowery_rider/core/shared_features/app_section/presentation/view_model/cubit/app_section_cubit.dart';
import 'package:flowery_rider/modules/auth/presentation/login/view_model/cubit/login_cubit.dart';
import 'package:flowery_rider/modules/auth/presentation/login/views/login_view.dart';
import 'package:flowery_rider/modules/auth/presentation/onboarding/view/onboarding_view.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/order_page/views/orders_view.dart';
import 'package:flowery_rider/modules/profile/domain/entities/driver_profile_entity.dart';
import 'package:flowery_rider/modules/profile/presentation/edit_my_info/view_model/cubit/edit_profile_cubit.dart';
import 'package:flowery_rider/modules/profile/presentation/edit_my_info/views/edit_my_info_view.dart';
import 'package:flowery_rider/modules/profile/presentation/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouter {
  static GoRouter getRouter({
    String initialLocation = AppRouterPaths.kHomeView,
    OrderEntity? initialOrder,
  }) => GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    initialExtra: initialOrder,
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
        path: AppRouterPaths.kHomeView,
        builder: (context, state) => BlocProvider(
          create: (context) =>
              getIt<HomeCubit>()..handleHomeIntent(GetPendingOrdersIntent()),
          child: const HomeView(),
        ),
      ),
      GoRoute(
        path: AppRouterPaths.kOrderDetailsView,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<OrderDetailsCubit>(),
          child: OrderDetailsView(order: state.extra as OrderEntity),
        ),
      ),
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
      GoRoute(
        path: AppRouterPaths.kOnboardingView,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: AppRouterPaths.kProfileView,
        builder: (context, state) => const ProfileView(),
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
      GoRoute(
        path: AppRouterPaths.kApplyView,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ApplyCubit>(),
          child: ApplyView(),
        ),
      ),
      GoRoute(
        path: AppRouterPaths.kApplySuccessView,
        builder: (context, state) => const ApplySuccessView(),
      ),
      GoRoute(
        path: AppRouterPaths.kOrdersView,
        builder: (context, state) => const OrdersPageView(),


      ),
      GoRoute(
        path: AppRouterPaths.kMapView,
        builder: (context, state) {
          final routeArgs = state.extra as MapRouteArgs;
          return BlocProvider(
            create: (context) =>
                getIt<MapCubit>()
                  ..handleMapIntent(StartMapRouteIntent(routeArgs: routeArgs)),
            child: const MapView(),
          );
        },
      ),
      GoRoute(
        path: AppRouterPaths.kOrderSuccessView,
        builder: (context, state) => const OrderSuccessView(),
      ),
    ],
  );
}
