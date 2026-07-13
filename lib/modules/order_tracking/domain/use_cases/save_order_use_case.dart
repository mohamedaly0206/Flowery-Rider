import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveOrderUseCase {
  final OrderTrackingRepoContract _repo;

  SaveOrderUseCase(this._repo);

  Future<BaseResponse<void>> saveOrder(
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
}
