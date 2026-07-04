import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';

import '../../../../domain/entities/order_status/order_details_status.dart';

class OrderDetailsState extends Equatable {
  final OrderDetailsStatus status;
  int get completedSteps => status.completedSteps;
  final BaseState updateOrderState;

  const OrderDetailsState({
    this.status = OrderDetailsStatus.accepted,
    this.updateOrderState = const BaseState(),
  });

  OrderDetailsState copyWith({
    OrderDetailsStatus? status,
    BaseState? updateOrderState,
  }) {
    return OrderDetailsState(
      status: status ?? this.status,
      updateOrderState: updateOrderState ?? this.updateOrderState,
    );
  }

  @override
  List<Object?> get props => [status, updateOrderState];
}
