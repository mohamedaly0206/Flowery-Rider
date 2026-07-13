import 'package:flowery_rider/modules/order_tracking/data/models/response/product_model.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItemModel {
  final ProductModel? product;
  final double? price;
  final int? quantity;
  @JsonKey(name: '_id')
  final String? id;

  const OrderItemModel({this.product, this.price, this.quantity, this.id});
  OrderItemEntity toEntity() => OrderItemEntity(
    id: id,
    price: price,
    quantity: quantity,
    product: product?.toEntity(),
  );
  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}
