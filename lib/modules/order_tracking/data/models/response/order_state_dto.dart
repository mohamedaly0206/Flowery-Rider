import 'package:json_annotation/json_annotation.dart';

enum OrderStateEnum {
  @JsonValue('pending')
  pending,

  @JsonValue('inProgress')
  inProgress,

  @JsonValue('canceled')
  canceled,

  @JsonValue('completed')
  completed,
}
