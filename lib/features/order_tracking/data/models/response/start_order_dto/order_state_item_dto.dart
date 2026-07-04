import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_state_entities/order_state_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_state_item_dto.g.dart';

@JsonSerializable()
class OrderStateItemDto {
  @JsonKey(name: "product")
  final String? product;
  @JsonKey(name: "price")
  final int? price;
  @JsonKey(name: "quantity")
  final int? quantity;
  @JsonKey(name: "_id")
  final String? id;

  OrderStateItemDto({this.product, this.price, this.quantity, this.id});

  factory OrderStateItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderStateItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderStateItemDtoToJson(this);
  OrderStateItemEntity toDomain() => OrderStateItemEntity(
    product: product,
    price: price,
    quantity: quantity,
    id: id,
  );
}
