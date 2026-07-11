import 'package:flowery_rider/modules/order_tracking/data/models/response/order_state_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_order_state_request.g.dart';

@JsonSerializable()
class UpdateOrderStateRequest {
  final OrderStateDto state;

  const UpdateOrderStateRequest({required this.state});

  factory UpdateOrderStateRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateOrderStateRequestToJson(this);
}
