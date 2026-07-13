import 'package:equatable/equatable.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/metadata_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';

class PendingOrdersEntity extends Equatable {
  final List<OrderEntity>? orders;
  final MetadataEntity? metadata;

  const PendingOrdersEntity({this.orders, this.metadata});

  @override
  List<Object?> get props => [orders, metadata];
}
