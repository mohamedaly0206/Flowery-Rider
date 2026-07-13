import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/driver_orders_response_model.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';

abstract interface class OrderTrackingRemoteDataSourceContract {
 Future<BaseResponse<PendingOrdersDto>> getPendingOrders();

  Future<BaseResponse<OrderStateResponseDto>> startOrder(
    String orderId,
  );

  Future<BaseResponse<OrderStateResponseDto>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  );

  Future<DriverOrdersResponseModel> getAllDriverOrders();
}
