import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/order_dto.dart';

abstract interface class OrderTrackingFirestoreDataSourceContract {
  Future<BaseResponse<void>> saveOrderToFirestore(
    String orderId,
    OrderDto order,
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
    String status, {
    String? userId,
  });

  Stream<String?> getOrderStatusStream(String orderId);

  Future<BaseResponse<OrderDto?>> getActiveOrderFromFirestore(String driverId);
}
