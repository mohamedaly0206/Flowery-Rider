import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateLocationUseCase {
  final OrderTrackingRepoContract _repo;

  UpdateLocationUseCase(this._repo);

  Future<BaseResponse<void>> updateLocation(
    String orderId,
    double lat,
    double lng,
  ) => _repo.updateDriverLocationInFirestore(orderId, lat, lng);
}
