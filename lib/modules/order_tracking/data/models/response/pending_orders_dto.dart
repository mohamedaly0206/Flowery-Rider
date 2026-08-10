import 'package:flowery_rider/modules/order_tracking/data/models/response/metadata_dto.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'order_dto.dart';

part 'pending_orders_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PendingOrdersDto {
  final String? message;

  final MetadataDto? metadata;

  final List<OrderDto>? orders;

  const PendingOrdersDto({this.message, this.metadata, this.orders});

  factory PendingOrdersDto.fromJson(Map<String, dynamic> json) =>
      _$PendingOrdersDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PendingOrdersDtoToJson(this);
  PendingOrdersEntity toDomain() => PendingOrdersEntity(
    orders: orders?.map((e) => e.toDomain()).toList(),
    metadata: metadata?.toDomain(),
  );
}
