import 'package:equatable/equatable.dart';
import 'package:flowery_rider/config/base_state/base_state.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_orders_entity.dart';

class OrdersState extends Equatable {
  final BaseState<DriverOrdersEntity> ordersState;

  const OrdersState({this.ordersState = const BaseState()});

  OrdersState copyWith({BaseState<DriverOrdersEntity>? ordersState}) {
    return OrdersState(ordersState: ordersState ?? this.ordersState);
  }

  @override
  List<Object?> get props => [ordersState];
}
