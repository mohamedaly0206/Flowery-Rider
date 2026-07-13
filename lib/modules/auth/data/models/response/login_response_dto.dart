import 'package:flowery_rider/modules/auth/domain/entities/login_response_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDto {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "token")
  String? token;

  LoginResponseDto({this.message, this.token});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
  LoginResponseEntity toDomain() {
    return LoginResponseEntity(message: message, token: token ?? '');
  }
}
