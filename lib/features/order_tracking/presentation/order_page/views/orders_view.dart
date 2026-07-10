import 'dart:async';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/config/di/di.dart';
import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/theme/app_text_styles.dart';
import 'package:flowery_rider/core/utilities/app_messages.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/core/widgets/custom_app_bar.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_page/view_model/cubit/orders_cubit.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_page/view_model/intent/orders_intent.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_page/view_model/state/orders_state.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_page/widgets/order_card_item.dart';
import 'package:flowery_rider/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class OrdersPageView extends StatelessWidget {
  const OrdersPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<OrdersCubit>()..handleIntent(GetAllDriverOrdersIntent()),
      child: const OrdersBodyView(),
    );
  }
}

class OrdersBodyView extends StatefulWidget {
  const OrdersBodyView({super.key});

  @override
  State<OrdersBodyView> createState() => _OrdersBodyViewState();
}

class _OrdersBodyViewState extends State<OrdersBodyView> {
  late final StreamSubscription<BaseEvent> _eventSubscription;

  @override
  void initState() {
    super.initState();
    _eventSubscription = context.read<OrdersCubit>().eventStream.listen((
      event,
    ) {
      if (!mounted) return;
      if (event is DisplayError) {
        AppMessages.showError(context, message: event.message);
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
    final localizations = AppLocalizations.of(context)!;

    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        final ordersState = state.ordersState;
        final allOrders = ordersState.data?.orders ?? [];

        final canceledOrders = allOrders
            .where((item) => item.order?.state == AppStrings.canceled)
            .toList();
        final completedOrders = allOrders
            .where((item) => item.order?.state == AppStrings.completedCa)
            .toList();

        if (ordersState.isLoading && allOrders.isEmpty) {
          return const Scaffold(
            body: Center(
              child: SpinKitFadingCircle(
                color: AppColors.primaryColor,
                size: 50,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: CustomAppBar(
            title: localizations.myOrders,
            hasBackButton: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFilterCard(
                        count: '${canceledOrders.length}',
                        label: localizations.cancelled,
                        assetName: Assets.icons.cancelIcon,
                        iconColor: AppColors.errorColor,
                        backgroundColor: AppColors.secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterCard(
                        count: '${completedOrders.length}',
                        label: localizations.completed,
                        assetName: Assets.icons.checkCircleIcon,
                        iconColor: AppColors.successColor,
                        backgroundColor: AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                  localizations.recentOrders,
                  style: AppTextStyles.textStyleMedium18.copyWith(),
                ),
              ),

              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: () async {
                    context.read<OrdersCubit>().handleIntent(
                      GetAllDriverOrdersIntent(),
                    );
                  },
                  child: allOrders.isEmpty
                      ? Center(
                          child: Text(
                            localizations.noOrdersYet,
                            style: AppTextStyles.textStyleRegular14.copyWith(
                              color: AppColors.greyColor,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: allOrders.length,
                          itemBuilder: (context, index) {
                            return OrderCardItem(orderEntity: allOrders[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterCard({
    required String count,
    required String label,
    required String assetName,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(count, style: AppTextStyles.textStyleMedium18),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                assetName,
                color: iconColor,
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 4),
              Text(label, style: AppTextStyles.textStyleMedium16),
            ],
          ),
        ],
      ),
    );
  }
}
