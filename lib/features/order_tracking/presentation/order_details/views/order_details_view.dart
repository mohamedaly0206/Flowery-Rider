import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/utilities/custom_alert_dialog.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_state_dto.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/widgets/order_item_card.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/widgets/title_section.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../view_model/cubit/order_details_cubit.dart';
import '../view_model/state/order_details_state.dart';
import '../widgets/order_action_button.dart';
import '../../widgets/order_address_card.dart';
import '../widgets/order_info_row_card.dart';
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
    _eventSubscription = context.read<OrderDetailsCubit>().eventStream.listen((
      event,
    ) {
      if (!mounted) return;

      if (event is NavigateEvent) {
        GoRouter.of(context).go(event.routeName);
      } else if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
      } else if (event is DisplaySuccess) {
        AppMessages.showSuccess(context, message: event.message);
      }
    });
  }

  @override
  void dispose() {
    // 3. Prevent memory leaks by canceling the subscription
    _eventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
      builder: (context, state) {
        final formattedDate = DateFormat(
          'dd MMM yyyy, hh:mm a',
        ).format(DateTime.parse(widget.order.createdAt.toString()).toLocal());

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            await showCustomAlertDialog(
              context: context,
              title: appLocalization.areYouSureCancelOrder,
              primaryButtonText: appLocalization.cancel,
              onPrimaryPressed: () {
                context.read<OrderDetailsCubit>().handleOrderDetailsIntent(
                  UpdateOrderStateIntent(
                    orderId: widget.order.id ?? '',
                    request: UpdateOrderStateRequest(
                      state: OrderStateDto.canceled,
                    ),
                  ),
                );
              },
              secondaryButtonText: appLocalization.close,
            );
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
                  OrderProgressSteps(completedSteps: state.status.index),
                  const SizedBox(height: 24),
                  OrderStatusCard(
                    status: state.status,
                    orderId: widget.order.id ?? '',
                    date: formattedDate,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleSection(title: appLocalization.pickupAddress),
                          const SizedBox(height: 16),
                          OrderAddressCard(
                            title: widget.order.store?.name ?? '',
                            address: widget.order.store?.address ?? '',
                            imagePath: widget.order.store?.image ?? '',
                          ),
                          const SizedBox(height: 24),
                          TitleSection(title: appLocalization.userAddress),
                          const SizedBox(height: 16),
                          OrderAddressCard(
                            title: widget.order.user?.firstName ?? '',
                            address: widget.order.shippingAddress?.street ?? '',
                            imagePath: widget.order.user?.photo ?? '',
                          ),
                          const SizedBox(height: 24),
                          TitleSection(title: appLocalization.orderDetails),
                          const SizedBox(height: 16),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.order.orderItems?.length ?? 0,
                            itemBuilder: (context, index) => OrderItemCard(
                              title:
                                  widget
                                      .order
                                      .orderItems?[index]
                                      .product
                                      ?.title ??
                                  '',
                              price:
                                  widget.order.orderItems?[index].price
                                      .toString() ??
                                  '',
                              quantity:
                                  '${widget.order.orderItems?[index].quantity}x',
                              imagePath:
                                  widget
                                      .order
                                      .orderItems?[index]
                                      .product
                                      ?.imgCover ??
                                  '',
                            ),
                          ),
                          OrderInfoRowCard(
                            title: appLocalization.total,
                            value:
                                '${appLocalization.egp} ${widget.order.totalPrice.toString()}',
                          ),
                          const SizedBox(height: 8),
                          OrderInfoRowCard(
                            title: appLocalization.paymentMethod,
                            value: widget.order.paymentType ?? '',
                          ),
                          const SizedBox(height: 24),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
