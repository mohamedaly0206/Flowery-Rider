import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/remote/data_sources/order_tracking_remote_data_source_contract.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderTrackingRepoContract)
class OrderTrackingRepoImpl implements OrderTrackingRepoContract {
  final OrderTrackingRemoteDataSourceContract
  _orderTrackingRemoteDataSourceContract;

  OrderTrackingRepoImpl(this._orderTrackingRemoteDataSourceContract);

  @override
  Future<BaseResponse<PendingOrdersEntity>> getPendingOrders() async {
    final response = await _orderTrackingRemoteDataSourceContract
        .getPendingOrders();
    switch (response) {
      case SuccessBaseResponse<PendingOrdersDto>():
        return SuccessBaseResponse<PendingOrdersEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<PendingOrdersDto>():
        return ErrorBaseResponse<PendingOrdersEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<OrderEntity>> startOrder(String orderId) async {
    final response = await _orderTrackingRemoteDataSourceContract.startOrder(
      orderId,
    );
    switch (response) {
      case SuccessBaseResponse<OrderDto>():
        return SuccessBaseResponse<OrderEntity>(data: response.data.toDomain());
      case ErrorBaseResponse<OrderDto>():
        return ErrorBaseResponse<OrderEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<OrderEntity>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  ) async {
    final response = await _orderTrackingRemoteDataSourceContract
        .updateOrderState(orderId, request);
    switch (response) {
      case SuccessBaseResponse<OrderDto>():
        return SuccessBaseResponse<OrderEntity>(data: response.data.toDomain());
      case ErrorBaseResponse<OrderDto>():
        return ErrorBaseResponse<OrderEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }
}
