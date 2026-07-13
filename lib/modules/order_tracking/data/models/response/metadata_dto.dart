import 'package:json_annotation/json_annotation.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/metadata_entity.dart';

part 'metadata_dto.g.dart';

@JsonSerializable()
class MetadataDto {
  @JsonKey(name: 'currentPage')
  final int? currentPage;

  @JsonKey(name: 'totalPages')
  final int? totalPages;

  @JsonKey(name: 'totalItems')
  final int? totalItems;

  @JsonKey(name: 'limit')
  final int? limit;

  const MetadataDto({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
  });

  factory MetadataDto.fromJson(Map<String, dynamic> json) =>
      _$MetadataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MetadataDtoToJson(this);

  MetadataEntity toDomain() {
    return MetadataEntity(
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      limit: limit,
    );
  }
}
