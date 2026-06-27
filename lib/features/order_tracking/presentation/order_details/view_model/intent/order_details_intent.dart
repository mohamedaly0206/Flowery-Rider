import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';

sealed class OrderDetailsIntent {}

class UpdateOrderDetailsStatuesIntent extends OrderDetailsIntent {}

class UpdateOrderStateIntent extends OrderDetailsIntent {
  final String orderId;
  final UpdateOrderStateRequest request;
  UpdateOrderStateIntent({required this.orderId, required this.request});
}
