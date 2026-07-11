import 'package:flowery_rider/modules/order_tracking/domain/entities/response/store_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'store_model.g.dart';

@JsonSerializable()
class StoreModel {
  final String? name;
  final String? image;
  final String? address;
  final String? phoneNumber;
  final String? latLong;

  const StoreModel({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });
  StoreEntity toEntity() => StoreEntity(
    name: name,
    image: image,
    address: address,
    phoneNumber: phoneNumber,
    latLong: latLong,
  );
  factory StoreModel.fromJson(Map<String, dynamic> json) =>
      _$StoreModelFromJson(json);
}
