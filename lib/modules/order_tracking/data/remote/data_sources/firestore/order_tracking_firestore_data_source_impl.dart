import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flowery_rider/config/base_response/base_response.dart';
import 'package:flowery_rider/core/errors/failures.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/firebase_models/firestore_collections.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/firebase_models/firestore_order_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/models/response/order_dto.dart';
import 'package:flowery_rider/modules/order_tracking/data/remote/data_sources/firestore/order_tracking_firestore_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: OrderTrackingFirestoreDataSourceContract)
class OrderTrackingFirestoreDataSourceImpl
    implements OrderTrackingFirestoreDataSourceContract {
  final FirebaseFirestore _firestore;

  OrderTrackingFirestoreDataSourceImpl(this._firestore);

  CollectionReference<FirestoreOrderDto> get _ordersCollection => _firestore
      .collection(FirestoreCollections.orders)
      .withConverter<FirestoreOrderDto>(
        fromFirestore: (snapshot, _) =>
            FirestoreOrderDto.fromJson(snapshot.data()!),
        toFirestore: (order, _) => order.toJson(),
      );

  @override
  Future<BaseResponse<void>> saveOrderToFirestore(
    String orderId,
    OrderDto order,
    String driverId,
    String driverName,
    String driverPhone,
    double lat,
    double lng,
  ) async {
    try {
      await _ordersCollection
          .doc(orderId)
          .set(
            FirestoreOrderDto(
              status: FirestoreOrderStatus.accepted,
              driverId: driverId,
              driverName: driverName,
              driverPhone: driverPhone,
              driverLocation: GeoPoint(lat, lng),
              orderDetails: order,
              acceptedAt: DateTime.now(),
            ),
          );

      return SuccessBaseResponse<void>(data: null);
    } catch (e) {
      log('Error saving order to Firestore: $e');

      return ErrorBaseResponse<void>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<void>> updateDriverLocationInFirestore(
    String orderId,
    double lat,
    double lng,
  ) async {
    try {
      if (orderId.trim().isEmpty) {
        return ErrorBaseResponse<void>(errorMessage: AppStrings.errorMessage);
      }

      await _ordersCollection.doc(orderId).update({
        FirestoreFields.driverLocation: GeoPoint(lat, lng),
        FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
      });

      return SuccessBaseResponse<void>(data: null);
    } catch (e) {
      return ErrorBaseResponse<void>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Future<BaseResponse<void>> updateOrderStatusInFirestore(
    String orderId,
    String status,
  ) async {
    try {
      await _ordersCollection.doc(orderId).update({
        FirestoreFields.status: status,
        '${FirestoreFields.orderDetails}.state':
            FirestoreOrderStatus.inProgress,
        FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
      });
      return SuccessBaseResponse<void>(data: null);
    } catch (e) {
      return ErrorBaseResponse<void>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }

  @override
  Stream<String?> getOrderStatusStream(String orderId) {
    if (orderId.trim().isEmpty) {
      log('Cannot track order status: orderId is empty');
      return const Stream.empty();
    }

    return _ordersCollection
        .doc(orderId)
        .snapshots()
        .map((snapshot) => snapshot.data()?.status);
  }

  @override
  Future<BaseResponse<OrderDto?>> getActiveOrderFromFirestore(
    String driverId,
  ) async {
    try {
      final snapshot = await _ordersCollection
          .where(FirestoreFields.driverId, isEqualTo: driverId)
          .where(
            FirestoreFields.status,
            whereIn: FirestoreOrderStatus.activeStatuses,
          )
          .limit(1)
          .get();

      return SuccessBaseResponse<OrderDto?>(
        data: snapshot.docs.isEmpty
            ? null
            : snapshot.docs.first.data().orderDetails,
      );
    } catch (e) {
      return ErrorBaseResponse<OrderDto?>(
        errorMessage: ServerFailure.failureHandler(e).errorMessage,
      );
    }
  }
}
