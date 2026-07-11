import 'package:flowery_rider/modules/auth/domain/entities/logout_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logout_response_dto.g.dart';

@JsonSerializable()
class LogOutResponseDto {
  @JsonKey(name: "message")
  final String? message;

  LogOutResponseDto({this.message});

  factory LogOutResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LogOutResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogOutResponseDtoToJson(this);
  LogoutResponseEntity toDomain() {
    return LogoutResponseEntity(message: message ?? '');
  }
}
