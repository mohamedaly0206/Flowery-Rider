import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';

abstract interface class OrderTrackingRemoteDataSourceContract {
  Future<BaseResponse<PendingOrdersDto>> getPendingOrders();
  Future<BaseResponse<OrderStateResponseDto>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  );

  Future<BaseResponse<OrderStateResponseDto>> startOrder(String orderId);

  // Firestore methods
  Future<void> saveOrderToFirestore(
    String orderId,
    OrderDto order,
    String driverId,
    String driverName,
    String driverPhone,
    double lat,
    double lng,
  );
  Future<void> updateDriverLocationInFirestore(
    String orderId,
    double lat,
    double lng,
  );
  Future<void> updateOrderStatusInFirestore(String orderId, String status);
  Stream<String?> getOrderStatusStream(String orderId);
  Future<OrderDto?> getActiveOrderFromFirestore(String driverId);
}
