import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateStatuesUseCase {
  final OrderTrackingRepoContract _repo;

  UpdateStatuesUseCase(this._repo);
   Future<BaseResponse<void>> updateStatus(String orderId, String status) =>
      _repo.updateOrderStatusInFirestore(orderId, status);

}