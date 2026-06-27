import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/errors/failures.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/remote/api_client/order_tracking_api_client.dart';
import 'package:flowery_rider/features/order_tracking/data/remote/data_sources/order_tracking_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderTrackingRemoteDataSourceContract)
class OrderTrackingRemoteDataSourceImpl
    implements OrderTrackingRemoteDataSourceContract {
  final OrderTrackingApiClient _orderTrackingApiClient;
  OrderTrackingRemoteDataSourceImpl(this._orderTrackingApiClient);

  @override
  Future<BaseResponse<PendingOrdersDto>> getPendingOrders() async {
    try {
      final response = await _orderTrackingApiClient.getPendingOrders();
      return SuccessBaseResponse<PendingOrdersDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<PendingOrdersDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<OrderDto>> startOrder(String orderId) async {
    try {
      final response = await _orderTrackingApiClient.startOrder(orderId);
      return SuccessBaseResponse<OrderDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<OrderDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<OrderDto>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  ) async {
    try {
      final response = await _orderTrackingApiClient.updateOrderState(
        orderId,
        request,
      );
      return SuccessBaseResponse<OrderDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<OrderDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }
}
