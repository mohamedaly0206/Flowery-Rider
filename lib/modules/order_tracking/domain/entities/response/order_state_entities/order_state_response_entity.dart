import 'package:equatable/equatable.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_state_entities/order_state_entity.dart';

class OrderStateResponseEntity extends Equatable {
  final String? message;
  final OrderStateEntity? orders;

  const OrderStateResponseEntity({this.message, this.orders});
  @override
  List<Object?> get props => [message, orders];
}
