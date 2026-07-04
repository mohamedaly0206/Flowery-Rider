import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';

class PendingOrdersEntity extends Equatable {
  final List<OrderEntity>? orders;

  const PendingOrdersEntity({this.orders});

  @override
  List<Object?> get props => [orders];
}
