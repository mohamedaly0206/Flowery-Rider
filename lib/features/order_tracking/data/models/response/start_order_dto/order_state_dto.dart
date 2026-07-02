import 'package:flowery_rider/features/order_tracking/data/models/response/start_order_dto/order_state_item_dto.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_state_entities/order_state_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_state_dto.g.dart';

@JsonSerializable()
class OrdersStateDto {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "user")
  final String? user;
  @JsonKey(name: "orderItems")
  final List<OrderStateItemDto>? orderItems;
  @JsonKey(name: "totalPrice")
  final int? totalPrice;
  @JsonKey(name: "paymentType")
  final String? paymentType;
  @JsonKey(name: "isPaid")
  final bool? isPaid;
  @JsonKey(name: "isDelivered")
  final bool? isDelivered;
  @JsonKey(name: "state")
  final String? state;
  @JsonKey(name: "createdAt")
  final DateTime? createdAt;
  @JsonKey(name: "updatedAt")
  final DateTime? updatedAt;
  @JsonKey(name: "orderNumber")
  final String? orderNumber;
  @JsonKey(name: "__v")
  final int? v;

  OrdersStateDto({
    this.id,
    this.user,
    this.orderItems,
    this.totalPrice,
    this.paymentType,
    this.isPaid,
    this.isDelivered,
    this.state,
    this.createdAt,
    this.updatedAt,
    this.orderNumber,
    this.v,
  });

  factory OrdersStateDto.fromJson(Map<String, dynamic> json) =>
      _$OrdersStateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersStateDtoToJson(this);
  OrderStateEntity toDomain() => OrderStateEntity(
    id: id,
    user: user,
    orderItems: orderItems?.map((e) => e.toDomain()).toList(),
    totalPrice: totalPrice,
    paymentType: paymentType,
    isPaid: isPaid,
    state: state,
    createdAt: createdAt,
    updatedAt: updatedAt,
    orderNumber: orderNumber,
  );
}
