import 'package:flowery_rider/modules/order_tracking/data/models/response/start_order_dto/order_state_dto.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'orders_state_response_dto.g.dart';

@JsonSerializable()
class OrderStateResponseDto {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "orders")
  final OrdersStateDto? orders;

  OrderStateResponseDto({this.message, this.orders});

  factory OrderStateResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OrderStateResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStateResponseDtoToJson(this);
  OrderStateResponseEntity toDomain() =>
      OrderStateResponseEntity(message: message, orders: orders?.toDomain());
}
