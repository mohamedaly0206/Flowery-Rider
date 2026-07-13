import 'package:equatable/equatable.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/metadata_entity.dart';

class DriverOrdersEntity extends Equatable {
  final List<DriverOrderEntity>? orders;
  final MetadataEntity? metadata;

  const DriverOrdersEntity({this.orders, this.metadata});

  @override
  List<Object?> get props => [orders, metadata];
}
