import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateOrderStateUseCase {
  final OrderTrackingRepoContract _orderTrackingRepoContract;
  UpdateOrderStateUseCase(this._orderTrackingRepoContract);

  Future<BaseResponse<OrderStateResponseEntity>> call(
    String orderId,
    UpdateOrderStateRequest request,
  ) => _orderTrackingRepoContract.updateOrderState(orderId, request);
}
