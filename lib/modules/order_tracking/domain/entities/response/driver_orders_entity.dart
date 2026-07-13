import 'package:equatable/equatable.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_order_entity.dart';

class DriverOrdersEntity extends Equatable {
  final List<DriverOrderEntity>? orders;

  const DriverOrdersEntity({this.orders});

  @override
  List<Object?> get props => [orders];
}
