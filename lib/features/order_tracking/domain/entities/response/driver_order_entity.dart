import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_detail_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/store_entity.dart';

class DriverOrderEntity extends Equatable {
  final String? id;
  final String? driver;
  final OrderDetailEntity? order;
  final StoreEntity? store;

  const DriverOrderEntity({this.id, this.driver, this.order, this.store});

  @override
  List<Object?> get props => [id, driver, order, store];
}
