import 'dart:async';

import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/router/router_paths.dart';
import 'package:flowery_rider/core/services/location_service.dart';
import 'package:flowery_rider/core/values/app_strings.dart';
import 'package:flowery_rider/features/order_tracking/data/models/request/update_order_state_request.dart';
import 'package:flowery_rider/features/order_tracking/data/models/response/order_state_dto.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/order_status/order_details_status.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/firestore_order_use_case.dart';
import 'package:flowery_rider/features/order_tracking/domain/use_cases/update_order_state_use_case.dart';
import 'package:flowery_rider/features/order_tracking/domain/entities/map_route_args.dart';
import 'package:flowery_rider/features/order_tracking/presentation/order_details/view_model/intent/order_details_intent.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../state/order_details_state.dart';

@injectable
class OrderDetailsCubit extends BaseCubit<OrderDetailsState, BaseEvent> {
  final UpdateOrderStateUseCase _updateOrderStateUseCase;
  final FirestoreOrderUseCase _firestoreOrderUseCase;
  final LocationService _locationService;
  StreamSubscription? _locationSubscription;
  StreamSubscription? _firestoreStatusSubscription;
  String? _currentOrderId;
  OrderEntity? _order;

  OrderDetailsCubit(
    this._updateOrderStateUseCase,
    this._firestoreOrderUseCase,
    this._locationService,
  ) : super(const OrderDetailsState());

  void handleOrderDetailsIntent(OrderDetailsIntent intent) {
    switch (intent) {
      case UpdateOrderDetailsStatuesIntent():
        _advanceStatus();
        break;
      case OpenStoreMapIntent():
        _openMap(_storeRoutePoint());
        break;
      case OpenUserMapIntent():
        _openMap(_userRoutePoint());
        break;
    }
  }

  void initTracking(OrderEntity order) {
    final orderId = order.id ?? '';
    _order = order;
    _currentOrderId = orderId;
    emit(
      state.copyWith(order: order, formattedDate: _formatDate(order.createdAt)),
    );

    if (orderId.isEmpty) return;

    _locationSubscription = _locationService.getLocationStream()?.listen((
      position,
    ) {
      if (_currentOrderId != null) {
        _firestoreOrderUseCase.updateLocation(
          _currentOrderId!,
          position.latitude,
          position.longitude,
        );
      }
    });

    _firestoreStatusSubscription = _firestoreOrderUseCase
        .getOrderStatusStream(orderId)
        .listen((status) async {
          if (status == null) return;

          if (status == 'completed') {
            await _stopAndClearActiveOrder();
            return;
          }

          emit(
            state.copyWith(status: OrderDetailsStatus.values.byName(status)),
          );
        });
  }

  Future<void> _stopAndClearActiveOrder() async {
    _locationSubscription?.cancel();
    _firestoreStatusSubscription?.cancel();
    if (_currentOrderId != null) {
      await _updateOrderStateUseCase.call(
        _currentOrderId!,
        const UpdateOrderStateRequest(state: OrderStateDto.completed),
      );
    }
    emitEvent(NavigateEvent(routeName: AppRouterPaths.kOrderSuccessView));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _firestoreStatusSubscription?.cancel();
    return super.close();
  }

  Future<void> _advanceStatus() async {
    final nextStatus = state.status.next;
    emit(state.copyWith(status: nextStatus));

    if (_currentOrderId != null) {
      await _firestoreOrderUseCase.updateStatus(
        _currentOrderId!,
        nextStatus.name,
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';

    return DateFormat('dd MMM yyyy, hh:mm a').format(date.toLocal());
  }

  void _openMap(MapRoutePoint? routePoint) {
    if (routePoint == null) {
      emitEvent(const DisplayError(AppStrings.errorMessage));
      return;
    }

    emitEvent(
  NavigateEvent(
    routeName: AppRouterPaths.kMapView,
    extra: MapRouteArgs(
      routePoint: routePoint,
    
    ),
  ),
);
  }

  MapRoutePoint? _storeRoutePoint() {
    final order = _order;
    if (order == null) return null;

    final location = _parseLocationText(order.store?.latLong);
    if (location == null) return null;

   return MapRoutePoint(
  title: order.store?.name ?? '',
  address: order.store?.address ?? '',
  location: location,
  type: MapRoutePointType.store,
  order: order,
);
  }

  MapRoutePoint? _userRoutePoint() {
    final order = _order;
    if (order == null) return null;

    final location = _parseLatLong(
      order.shippingAddress?.lat,
      order.shippingAddress?.long,
    );
    if (location == null) return null;

   return MapRoutePoint(
  title: order.store?.name ?? '',
  address: order.store?.address ?? '',
  location: location,
  type: MapRoutePointType.store,
  order: order,
);
  }

  LatLng? _parseLocationText(String? value) {
    final matches = RegExp(
      r'-?\d+(?:\.\d+)?',
    ).allMatches(value ?? '').map((match) => double.parse(match.group(0)!));

    final coordinates = matches.toList();
    if (coordinates.length < 2) return null;

    return _latLngFromPair(coordinates[0], coordinates[1]);
  }

  LatLng? _parseLatLong(String? lat, String? long) {
    final latitude = double.tryParse(lat ?? '');
    final longitude = double.tryParse(long ?? '');
    if (latitude == null || longitude == null) return null;

    return _latLngFromPair(latitude, longitude);
  }

  LatLng? _latLngFromPair(double first, double second) {
    if (first.abs() <= 90 && second.abs() <= 180) {
      return LatLng(first, second);
    }

    if (second.abs() <= 90 && first.abs() <= 180) {
      return LatLng(second, first);
    }

    return null;
  }
}
