import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/response/enter_reset_email_entity.dart';
part 'enter_reset_email_dto.g.dart';

@JsonSerializable()
class EnterResetEmailDTO {
  final String message;
  final String info;

  EnterResetEmailDTO({required this.message, required this.info});

  factory EnterResetEmailDTO.fromJson(Map<String, dynamic> json) =>
      _$EnterResetEmailDTOFromJson(json);

  Map<String, dynamic> toJson() => _$EnterResetEmailDTOToJson(this);

  EnterResetEmailEntity toDomain() =>
      EnterResetEmailEntity(message: message, info: info);
}
