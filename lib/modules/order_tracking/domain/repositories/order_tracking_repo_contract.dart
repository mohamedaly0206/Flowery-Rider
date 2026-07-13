import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_orders_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/pending_orders_entity.dart';

abstract interface class OrderTrackingRepoContract {
  Future<BaseResponse<PendingOrdersEntity>> getPendingOrders();

  Future<BaseResponse<OrderStateResponseEntity>> startOrder(String orderId);

  Future<BaseResponse<OrderStateResponseEntity>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  );

  // Firestore methods
  Future<BaseResponse<void>> saveOrderToFirestore(
    String orderId,
    OrderEntity order,
    String driverId,
    String driverName,
    String driverPhone,
    double lat,
    double lng,
  );
  Future<BaseResponse<void>> updateDriverLocationInFirestore(
    String orderId,
    double lat,
    double lng,
  );
  Future<BaseResponse<void>> updateOrderStatusInFirestore(
    String orderId,
    String status,
  );
  Stream<String?> getOrderStatusStream(String orderId);
  Future<BaseResponse<OrderEntity?>> getActiveOrderFromFirestore(
    String driverId,
  );
  Future<BaseResponse<DriverOrdersEntity>> getAllDriverOrders();
}
