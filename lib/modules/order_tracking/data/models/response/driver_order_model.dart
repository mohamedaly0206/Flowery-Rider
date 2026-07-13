import 'package:flowery_rider/modules/order_tracking/data/models/response/order_detail_model.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/store_model.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_order_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_order_model.g.dart';

@JsonSerializable()
class DriverOrderModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? driver;
  final OrderDetailModel? order;
  final StoreModel? store;

  const DriverOrderModel({this.id, this.driver, this.order, this.store});
  DriverOrderEntity toEntity() {
    return DriverOrderEntity(
      id: id,
      driver: driver,
      order: order?.toEntity(),
      store: store?.toEntity(),
    );
  }

  factory DriverOrderModel.fromJson(Map<String, dynamic> json) =>
      _$DriverOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverOrderModelToJson(this);
}
