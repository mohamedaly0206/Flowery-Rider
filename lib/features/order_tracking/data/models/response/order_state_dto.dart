import 'package:json_annotation/json_annotation.dart';

enum OrderStateDto {
  @JsonValue('pending')
  pending,

  @JsonValue('inProgress')
  inProgress,

  @JsonValue('canceled')
  canceled,

  @JsonValue('completed')
  completed,
}
