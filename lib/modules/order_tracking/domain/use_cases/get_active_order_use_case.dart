import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetActiveOrderUseCase {
  final OrderTrackingRepoContract _repo;
  GetActiveOrderUseCase(this._repo);
   Future<BaseResponse<OrderEntity?>> getActiveOrder(String driverId) =>
      _repo.getActiveOrderFromFirestore(driverId);
}