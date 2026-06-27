import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/cubit/home_cubit.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/intent/home_intent.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/views/home_view.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/view_model/cubit/order_details_cubit.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/views/order_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

abstract class AppRouter {
  static GoRouter getRouter({
    String initialLocation = AppRouterPaths.kHomeView,
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
    ],
  );
}
