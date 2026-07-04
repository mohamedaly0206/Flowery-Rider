import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPendingOrdersUseCase {
  final OrderTrackingRepoContract _orderTrackingRepoContract;
  GetPendingOrdersUseCase(this._orderTrackingRepoContract);
  Future<BaseResponse<PendingOrdersEntity>> call() =>
      _orderTrackingRepoContract.getPendingOrders();
}
