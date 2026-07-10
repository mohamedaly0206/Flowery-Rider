import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';

import '../../../../domain/entities/order_status/order_details_status.dart';

class OrderDetailsState extends Equatable {
  final OrderEntity? order;
  final String formattedDate;
  final OrderDetailsStatus status;
  int get completedSteps => status.completedSteps;
  final BaseState updateOrderState;

  const OrderDetailsState({
    this.order,
    this.formattedDate = '',
    this.status = OrderDetailsStatus.accepted,
    this.updateOrderState = const BaseState(),
  });

  OrderDetailsState copyWith({
    OrderEntity? order,
    String? formattedDate,
    OrderDetailsStatus? status,
    BaseState? updateOrderState,
  }) {
    return OrderDetailsState(
      order: order ?? this.order,
      formattedDate: formattedDate ?? this.formattedDate,
      status: status ?? this.status,
      updateOrderState: updateOrderState ?? this.updateOrderState,
    );
  }

  @override
  List<Object?> get props => [order, formattedDate, status, updateOrderState];
}
