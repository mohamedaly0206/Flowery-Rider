import 'dart:developer';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/errors/failures.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/driver_orders_response_model.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/api_client/order_tracking_api_client.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/data_sources/api/order_tracking_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderTrackingRemoteDataSourceContract)
class OrderTrackingRemoteDataSourceImpl
    implements OrderTrackingRemoteDataSourceContract {
  final OrderTrackingApiClient _orderTrackingApiClient;

  OrderTrackingRemoteDataSourceImpl(this._orderTrackingApiClient);

  @override
  Future<BaseResponse<PendingOrdersDto>> getPendingOrders({
    int? page,
    int? limit,
  }) async {
    try {
      final response = await _orderTrackingApiClient.getPendingOrders(
        page: page,
        limit: limit,
      );
      return SuccessBaseResponse<PendingOrdersDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<PendingOrdersDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<OrderStateResponseDto>> startOrder(String orderId) async {
    try {
      final response = await _orderTrackingApiClient.startOrder(orderId);

      return SuccessBaseResponse<OrderStateResponseDto>(data: response);
    } catch (e) {
      log('Error starting order: $e');
      return ErrorBaseResponse<OrderStateResponseDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<OrderStateResponseDto>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  ) async {
    try {
      final response = await _orderTrackingApiClient.updateOrderState(
        orderId,
        request,
      );
      return SuccessBaseResponse<OrderStateResponseDto>(data: response);
    } catch (e) {
      return ErrorBaseResponse<OrderStateResponseDto>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<DriverOrdersResponseModel> getAllDriverOrders({
    int? page,
    int? limit,
  }) {
    return _orderTrackingApiClient.getAllDriverOrders(
      page: page,
      limit: limit,
    );
  }
}
