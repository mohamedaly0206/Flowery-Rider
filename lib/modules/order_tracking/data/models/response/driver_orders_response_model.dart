import 'package:flowery_rider/modules/order_tracking/data/models/response/driver_order_model.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/metadata_dto.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_orders_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_orders_response_model.g.dart';

@JsonSerializable()
class DriverOrdersResponseModel {
  final String? message;
  final MetadataDto? metadata;
  final List<DriverOrderModel>? orders;

  const DriverOrdersResponseModel({this.message, this.metadata, this.orders});
  DriverOrdersEntity toEntity() {
    return DriverOrdersEntity(
      orders: orders?.map((e) => e.toEntity()).toList(),
      metadata: metadata?.toDomain(),
    );
  }

  factory DriverOrdersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DriverOrdersResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrdersResponseModelToJson(this);
}
