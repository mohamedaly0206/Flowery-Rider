import 'package:flowery_rider/modules/order_tracking/domain/entities/response/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final String? description;
  @JsonKey(name: 'imgCover')
  final String? imgCover;
  final List<String>? images;
  final int? price;
  @JsonKey(name: 'priceAfterDiscount')
  final int? priceAfterDiscount;
  final int? discount;
  final double? rateAvg;
  final int? rateCount;
  final int? sold;
  final int? quantity;
  final String? category;
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  const ProductDto({
    this.id,
    this.title,
    this.description,
    this.imgCover,
    this.images,
    this.price,
    this.priceAfterDiscount,
    this.discount,
    this.rateAvg,
    this.rateCount,
    this.sold,
    this.quantity,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
  ProductEntity toDomain() => ProductEntity(
    id: id,
    title: title,
    imgCover: imgCover,
    quantity: quantity,
  );
}
