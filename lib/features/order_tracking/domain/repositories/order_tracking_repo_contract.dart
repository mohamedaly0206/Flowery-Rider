import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/pending_orders_entity.dart';

abstract interface class OrderTrackingRepoContract {
  Future<BaseResponse<PendingOrdersEntity>> getPendingOrders();

  Future<BaseResponse<OrderEntity>> startOrder(String orderId);

  Future<BaseResponse<OrderEntity>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  );
}
