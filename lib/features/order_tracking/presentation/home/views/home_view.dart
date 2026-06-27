import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
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
          return RefreshIndicator(
            backgroundColor: theme.colorScheme.onPrimary,
            onRefresh: () async {
              context.read<HomeCubit>().handleHomeIntent(
                GetPendingOrdersIntent(),
              );
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: state.getPendingOrdersState.data?.orders?.length ?? 0,
              itemBuilder: (context, index) {
                return DeliveryOrderCard(
                  order: state.getPendingOrdersState.data!.orders![index],
                  onReject: () {
                    cubit.handleHomeIntent(
                      RejectOrderIntent(
                        orderId:
                            state.getPendingOrdersState.data!.orders![index].id,
                      ),
                    );
                  },

                  onAccept: () {
                    final order =
                        state.getPendingOrdersState.data.orders![index];

                    cubit.handleHomeIntent(
                      StartOrderIntent(orderId: order.id, order: order),
                    );
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
