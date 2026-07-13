import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetOrderStatuesUseCase {
  final OrderTrackingRepoContract _repo;
    GetOrderStatuesUseCase(this._repo);
    Stream<String?> getOrderStatusStream(String orderId) =>
      _repo.getOrderStatusStream(orderId);
}