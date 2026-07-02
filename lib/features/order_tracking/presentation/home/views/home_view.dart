import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/core/values/fonts.gen.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/cubit/home_cubit.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/intent/home_intent.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/view_model/state/home_state.dart';
import 'package:flowery_rider/features/order_tracking/presentation/home/widgets/delivery_order_card.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<BaseEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<HomeCubit>();

    _subscription = cubit.eventStream.listen((event) {
      if (!mounted) return;

      if (event is NavigateEvent) {
        GoRouter.of(context).push(event.routeName, extra: event.extra);
      }

      if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
      }
      cubit.handleHomeIntent(GetPendingOrdersIntent());
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Text(
          AppLocalizations.of(context)!.floweryRider,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontFamily: FontFamily.iMFellEnglish,
          ),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();

          if (state.getPendingOrdersState.isLoading) {
            return SpinKitFadingCircle(color: theme.colorScheme.primary);
          }

          final orders = state.getPendingOrdersState.data?.orders ?? [];

          if (orders.isEmpty) {
            return RefreshIndicator(
              backgroundColor: theme.colorScheme.onPrimary,
              onRefresh: () async {
                cubit.handleHomeIntent(GetPendingOrdersIntent());
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.noOrdersFound,
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            backgroundColor: theme.colorScheme.onPrimary,
            onRefresh: () async {
              cubit.handleHomeIntent(GetPendingOrdersIntent());
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return DeliveryOrderCard(
                  order: orders[index],
                  onReject: () {
                    cubit.handleHomeIntent(
                      RejectOrderIntent(orderId: orders[index].id),
                    );
                  },
                  onAccept: () {
                    if (orders[index].state == AppStrings.pending) {
                      AppMessages.showError(
                        context,
                        message: AppLocalizations.of(
                          context,
                        )!.notAvailableOrder,
                      );
                    } else {
                      cubit.handleHomeIntent(
                        StartOrderIntent(
                          orderId: orders[index].id,
                          order: orders[index],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
