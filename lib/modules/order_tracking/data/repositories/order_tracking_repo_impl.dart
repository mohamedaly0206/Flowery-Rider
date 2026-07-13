import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/data_sources/firestore/order_tracking_firestore_data_source.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/data_sources/api/order_tracking_remote_data_source_contract.dart';
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
  final OrderTrackingFirestoreDataSourceContract
  _orderTrackingFirestoreDataSourceContract;

  OrderTrackingRepoImpl(
    this._orderTrackingRemoteDataSourceContract,
    this._orderTrackingFirestoreDataSourceContract,
  );

  @override
  Future<BaseResponse<PendingOrdersEntity>> getPendingOrders({
    int? page,
    int? limit,
  }) async {
    final response = await _orderTrackingRemoteDataSourceContract
        .getPendingOrders(page: page, limit: limit);
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
  Future<BaseResponse<void>> saveOrderToFirestore(
    String orderId,
    OrderEntity order,
    String driverId,
    String driverName,
    String driverPhone,
    double lat,
    double lng,
  ) {
    return _orderTrackingFirestoreDataSourceContract.saveOrderToFirestore(
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
  @override
  Future<BaseResponse<void>> updateDriverLocationInFirestore(
    String orderId,
    double lat,
    double lng,
  ) {
    return _orderTrackingFirestoreDataSourceContract
        .updateDriverLocationInFirestore(orderId, lat, lng);
  }

  @override
  Future<BaseResponse<void>> updateOrderStatusInFirestore(
    String orderId,
    String status,
  ) {
    return _orderTrackingFirestoreDataSourceContract
        .updateOrderStatusInFirestore(orderId, status);
  }

  @override
  Stream<String?> getOrderStatusStream(String orderId) {
    return _orderTrackingFirestoreDataSourceContract.getOrderStatusStream(
      orderId,
    );
  }

  @override
  @override
  Future<BaseResponse<OrderEntity?>> getActiveOrderFromFirestore(
    String driverId,
  ) async {
    final response = await _orderTrackingFirestoreDataSourceContract
        .getActiveOrderFromFirestore(driverId);

    switch (response) {
      case SuccessBaseResponse<OrderDto?>():
        return SuccessBaseResponse<OrderEntity?>(
          data: response.data?.toDomain(),
        );

      case ErrorBaseResponse<OrderDto?>():
        return ErrorBaseResponse<OrderEntity?>(
          errorMessage: response.errorMessage,
        );
    }
  }

  @override
  Future<BaseResponse<DriverOrdersEntity>> getAllDriverOrders({
    int? page,
    int? limit,
  }) async {
    try {
      final responseModel = await _orderTrackingRemoteDataSourceContract
          .getAllDriverOrders(page: page, limit: limit);
      return SuccessBaseResponse(data: responseModel.toEntity());
    } catch (error) {
      return ErrorBaseResponse(errorMessage: '');
    }
  }
}
