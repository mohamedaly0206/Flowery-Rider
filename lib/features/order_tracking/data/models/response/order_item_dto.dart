import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'product_dto.dart';

part 'order_item_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItemDto {
  final ProductDto? product;
  final double? price;
  final int? quantity;

  @JsonKey(name: '_id')
  final String? id;

  const OrderItemDto({this.product, this.price, this.quantity, this.id});

  factory OrderItemDto.fromJson(Map<String, dynamic> json) =>
      _$OrderItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);
  OrderItemEntity toDomain() => OrderItemEntity(
    product: product?.toDomain(),
    price: price,
    quantity: quantity,
    id: id,
  );
}
