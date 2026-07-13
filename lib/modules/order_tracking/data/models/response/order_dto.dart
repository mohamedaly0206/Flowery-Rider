import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'order_item_dto.dart';
import 'order_state_dto.dart';
import 'shipping_address_dto.dart';
import 'store_dto.dart';
import 'user_dto.dart';

part 'order_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderDto {
  @JsonKey(name: '_id')
  final String? id;

  final UserDto? user;

  @JsonKey(name: 'orderItems')
  final List<OrderItemDto>? orderItems;

  @JsonKey(name: 'totalPrice')
  final int? totalPrice;

  @JsonKey(name: 'paymentType')
  final String? paymentType;

  @JsonKey(name: 'isPaid')
  final bool? isPaid;

  @JsonKey(name: 'isDelivered')
  final bool? isDelivered;

  final OrderStateEnum? state;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  @JsonKey(name: 'orderNumber')
  final String? orderNumber;

  @JsonKey(name: '__v')
  final int? version;

  final StoreDto? store;

  @JsonKey(name: 'shippingAddress')
  final ShippingAddressDto? shippingAddress;

  @JsonKey(name: 'paidAt')
  final DateTime? paidAt;

  const OrderDto({
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
    this.version,
    this.store,
    this.shippingAddress,
    this.paidAt,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
  OrderEntity toDomain() => OrderEntity(
    id: id,
    user: user?.toDomain(),
    orderItems: orderItems?.map((e) => e.toDomain()).toList(),
    totalPrice: totalPrice,
    paymentType: paymentType,
    state: state,
    createdAt: createdAt,
    updatedAt: updatedAt,
    orderNumber: orderNumber,
    store: store?.toDomain(),
    shippingAddress: shippingAddress?.toDomain(),
  );
}
