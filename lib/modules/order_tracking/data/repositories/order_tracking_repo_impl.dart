import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/data_sources/order_tracking_remote_data_source_contract.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/driver_orders_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_state_entities/order_state_response_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/pending_orders_entity.dart';
import 'package:flowery_rider/modules/order_tracking/domain/repositories/order_tracking_repo_contract.dart';
import 'package:injectable/injectable.dart';

import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity_mapper.dart';

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
  Future<BaseResponse<OrderStateResponseEntity>> startOrder(
    String orderId,
  ) async {
    final response = await _orderTrackingRemoteDataSourceContract.startOrder(
      orderId,
    );
    switch (response) {
      case SuccessBaseResponse<OrderStateResponseDto>():
        return SuccessBaseResponse<OrderStateResponseEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<OrderStateResponseDto>():
        return ErrorBaseResponse<OrderStateResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<OrderStateResponseEntity>> updateOrderState(
    String orderId,
    UpdateOrderStateRequest request,
  ) async {
    final response = await _orderTrackingRemoteDataSourceContract
        .updateOrderState(orderId, request);
    switch (response) {
      case SuccessBaseResponse<OrderStateResponseDto>():
        return SuccessBaseResponse<OrderStateResponseEntity>(
          data: response.data.toDomain(),
        );
      case ErrorBaseResponse<OrderStateResponseDto>():
        return ErrorBaseResponse<OrderStateResponseEntity>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<void> saveOrderToFirestore(
    String orderId,
    OrderEntity order,
    String driverId,
    String driverName,
    String driverPhone,
    double lat,
    double lng,
  ) async {
    return _orderTrackingRemoteDataSourceContract.saveOrderToFirestore(
      orderId,
      order.toDto(),
      driverId,
      driverName,
      driverPhone,
      lat,
      lng,
    );
  }

  @override
  Future<void> updateDriverLocationInFirestore(
    String orderId,
    double lat,
    double lng,
  ) async {
    return _orderTrackingRemoteDataSourceContract
        .updateDriverLocationInFirestore(orderId, lat, lng);
  }

  @override
  Future<void> updateOrderStatusInFirestore(
    String orderId,
    String status,
  ) async {
    return _orderTrackingRemoteDataSourceContract.updateOrderStatusInFirestore(
      orderId,
      status,
    );
  }

  @override
  Stream<String?> getOrderStatusStream(String orderId) {
    return _orderTrackingRemoteDataSourceContract.getOrderStatusStream(orderId);
  }

  @override
  Future<OrderEntity?> getActiveOrderFromFirestore(String driverId) async {
    final dto = await _orderTrackingRemoteDataSourceContract
        .getActiveOrderFromFirestore(driverId);
    return dto?.toDomain();
  }

  @override
  Future<BaseResponse<DriverOrdersEntity>> getAllDriverOrders() async {
    try {
      final responseModel = await _orderTrackingRemoteDataSourceContract
          .getAllDriverOrders();
      return SuccessBaseResponse(data: responseModel.toEntity());
    } catch (error) {
      return ErrorBaseResponse(errorMessage: '');
    }
  }
}
