import 'package:flowery_rider/modules/order_tracking/domain/entities/response/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: '_id')
  final String? id;
  final double? price;

  const ProductModel({this.id, this.price});
  ProductEntity toEntity() => ProductEntity(id: id, price: price);
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
