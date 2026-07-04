import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirestoreOrderUseCase {
  final OrderTrackingRepoContract _repo;

  FirestoreOrderUseCase(this._repo);

  Future<void> saveOrder(
    String orderId,
    OrderEntity order,
    String driverId,
    String driverName,
    String driverPhone,
    double lat,
    double lng,
  ) => _repo.saveOrderToFirestore(
    orderId,
    order,
    driverId,
    driverName,
    driverPhone,
    lat,
    lng,
  );

  Future<void> updateLocation(String orderId, double lat, double lng) =>
      _repo.updateDriverLocationInFirestore(orderId, lat, lng);

  Future<void> updateStatus(String orderId, String status) =>
      _repo.updateOrderStatusInFirestore(orderId, status);

  Stream<String?> getOrderStatusStream(String orderId) =>
      _repo.getOrderStatusStream(orderId);

  Future<OrderEntity?> getActiveOrder(String driverId) =>
      _repo.getActiveOrderFromFirestore(driverId);
}
