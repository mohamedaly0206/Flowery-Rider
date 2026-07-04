import 'dart:developer';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/errors/failures.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/pending_orders_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/start_order_dto/orders_state_response_dto.dart';
import 'package:flowery_rider/features/order_tracking/data/remote/api_client/order_tracking_api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider/features/order_tracking/data/remote/data_sources/order_tracking_remote_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderTrackingRemoteDataSourceContract)
class OrderTrackingRemoteDataSourceImpl
    implements OrderTrackingRemoteDataSourceContract {
  final OrderTrackingApiClient _orderTrackingApiClient;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  Future<void> saveOrderToFirestore(
    String orderId,
    OrderDto order,
    String driverId,
    String driverName,
    String driverPhone,
    double lat,
    double lng,
  ) async {
    final orderJson = order.toJson();
    await _firestore.collection('orders').doc(orderId).set({
      'status': 'accept',
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverLocation': GeoPoint(lat, lng),
      'updatedAt': FieldValue.serverTimestamp(),
      'orderDetails': orderJson,
    });
  }

  @override
  Future<void> updateDriverLocationInFirestore(
    String orderId,
    double lat,
    double lng,
  ) async {
    if (orderId.trim().isEmpty) {
      log('Cannot update driver location: orderId is empty');
      return;
    }

    await _firestore.collection('orders').doc(orderId).update({
      'driverLocation': GeoPoint(lat, lng),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  @override
  Future<void> updateOrderStatusInFirestore(
    String orderId,
    String status,
  ) async {
    String orderState = 'inProgress';
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
      'orderDetails.state': orderState,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<String?> getOrderStatusStream(String orderId) {
    // 2. Guard against empty orderId
    if (orderId.trim().isEmpty) {
      log('Cannot track order status: orderId is empty');
      return const Stream.empty();
    }

    return _firestore.collection('orders').doc(orderId).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!['status'] as String?;
      }
      return null;
    });
  }

  @override
  Future<OrderDto?> getActiveOrderFromFirestore(String driverId) async {
    final querySnapshot = await _firestore
        .collection('orders')
        .where('driverId', isEqualTo: driverId)
        .get();

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      if (data['status'] != 'completed' && data.containsKey('orderDetails')) {
        return OrderDto.fromJson(data['orderDetails'] as Map<String, dynamic>);
      }
    }
    return null;
  }
}
