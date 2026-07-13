import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/cubit/home_cubit.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/home/view_model/state/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OrderDecisionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;
  final String orderId;

  const OrderDecisionButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading = isPrimary
            ? state.startOrderState.isLoading &&
                  state.selectedOrderId == orderId &&
                  state.action == OrderAction.accept
            : state.isLoading &&
                  state.selectedOrderId == orderId &&
                  state.action == OrderAction.reject;
        return SizedBox(
          height: 36,
          child: isPrimary
              ? ElevatedButton(
                  onPressed: isLoading ? null : onPressed,
                  child: isLoading
                      ? Center(
                          child: SpinKitFadingCircle(
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        )
                      : Text(label),
                )
              : OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  onPressed: isLoading ? null : onPressed,
                  child: isLoading
                      ? Center(
                          child: SpinKitFadingCircle(
                            color: Theme.of(context).colorScheme.primary,
                            size: 20,
                          ),
                        )
                      : Text(label),
                ),
        );
      },
    );
  }
}
