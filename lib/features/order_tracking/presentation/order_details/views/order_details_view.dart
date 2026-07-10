import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/widgets/order_details_content.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../view_model/cubit/order_details_cubit.dart';
import '../view_model/state/order_details_state.dart';
import '../widgets/order_action_button.dart';
import '../widgets/order_progress_steps.dart';
import '../widgets/order_status_card.dart';

class OrderDetailsView extends StatefulWidget {
  final OrderEntity order;
  const OrderDetailsView({super.key, required this.order});
  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  late StreamSubscription _eventSubscription;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OrderDetailsCubit>();
    cubit.initTracking(widget.order);

    _eventSubscription = cubit.eventStream.listen((event) {
      if (!mounted) return;

      if (event is NavigateEvent) {
        if (event.routeName == AppRouterPaths.kMapView) {
          context.push(event.routeName, extra: event.extra);
        } else {
          context.go(event.routeName, extra: event.extra);
        }
      } else if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
      } else if (event is DisplaySuccess) {
        AppMessages.showSuccess(context, message: event.message);
      }
    });
  }

  @override
  void dispose() {
    _eventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
          },
          child: Scaffold(
            appBar: CustomAppBar(
              title: AppLocalizations.of(context)!.orderDetails,
              hasBackButton: false,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  OrderProgressSteps(completedSteps: state.completedSteps),
                  const SizedBox(height: 24),
                  OrderStatusCard(
                    status: state.status,
                    orderId: state.order?.id ?? '',
                    date: state.formattedDate,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: OrderDetailsContent(
                      order: state.order,
                      onPickupAddressTap: () {
                        context
                            .read<OrderDetailsCubit>()
                            .handleOrderDetailsIntent(OpenStoreMapIntent());
                      },
                      onUserAddressTap: () {
                        context
                            .read<OrderDetailsCubit>()
                            .handleOrderDetailsIntent(OpenUserMapIntent());
                      },
                    ),
                  ),
                  OrderActionButton(
                    status: state.status,
                    onPressed: () {
                      context
                          .read<OrderDetailsCubit>()
                          .handleOrderDetailsIntent(
                            UpdateOrderDetailsStatuesIntent(),
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
