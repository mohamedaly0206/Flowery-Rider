import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_orders_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAllDriverOrdersUseCase {
   final OrderTrackingRepoContract _getAllDriverOrdersUseCase;

  GetAllDriverOrdersUseCase(this._getAllDriverOrdersUseCase);

  Future<BaseResponse<DriverOrdersEntity>> call() async {
    return await _getAllDriverOrdersUseCase.getAllDriverOrders();
  }
}
