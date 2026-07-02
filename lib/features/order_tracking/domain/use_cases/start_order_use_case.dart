import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class StartOrderUseCase {
  final OrderTrackingRepoContract _orderTrackingRepoContract;

  StartOrderUseCase(this._orderTrackingRepoContract);

  Future<BaseResponse<OrderStateResponseEntity>> call(String orderId) =>
      _orderTrackingRepoContract.startOrder(orderId);
}
