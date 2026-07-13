import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/order_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'firestore_order_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class FirestoreOrderDto {
  final String status;

  final String driverId;

  final String driverName;

  final String driverPhone;
  final DateTime acceptedAt;

  @JsonKey(
    fromJson: _geoPointFromJson,
    toJson: _geoPointToJson,
  )
  final GeoPoint driverLocation;

  final OrderDto orderDetails;

  const FirestoreOrderDto({
    required this.status,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.driverLocation,
    required this.orderDetails, required this.acceptedAt,
  });

  factory FirestoreOrderDto.fromJson(Map<String, dynamic> json) =>
      _$FirestoreOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FirestoreOrderDtoToJson(this);

  static GeoPoint _geoPointFromJson(Object? json) =>
      json as GeoPoint;

  static Object? _geoPointToJson(GeoPoint point) => point;
}