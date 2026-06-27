import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/pending_orders_dto.dart';

abstract interface class OrderTrackingRemoteDataSourceContract {
  Future<BaseResponse<PendingOrdersDto>> getPendingOrders();
  Future<BaseResponse<OrderDto>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  );

  Future<BaseResponse<OrderDto>> startOrder(String orderId);
}
