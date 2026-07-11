import 'dart:async';

import 'package:flowery_rider/config/base_cubit/base_cubit.dart';
import 'package:flowery_rider/config/base_event/base_event.dart';
import 'package:flowery_rider/core/services/location_service.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/map_route_args.dart';
import 'package:flowery_rider/core/services/osrm_route_service.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/map/view_model/intent/map_intent.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/map/view_model/state/map_state.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@injectable
class MapCubit extends BaseCubit<MapState, BaseEvent> {
  final LocationService _locationService;
  final OsrmRouteService _routeService;
  StreamSubscription? _locationSubscription;
  int _routeRequestId = 0;
  MapCubit(this._locationService, this._routeService) : super(const MapState());

  void handleMapIntent(MapIntent intent) {
    switch (intent) {
      case StartMapRouteIntent():
        _startRoute(intent.routeArgs);
        break;
    }
  }

  void _startRoute(MapRouteArgs routeArgs) {
    emit(
      state.copyWith(
        routePoint: routeArgs.routePoint,
        routePoints: const [],
        isLoading: true,
        errorMessage: '',
      ),
    );

    _locationSubscription?.cancel();
    final locationStream = _locationService.getLocationStream();
    if (locationStream == null) {
      emit(state.copyWith(isLoading: false, errorMessage: ''));
      return;
    }

    _locationSubscription = locationStream.listen(
      (position) {
        _updateDeliveryLocation(LatLng(position.latitude, position.longitude));
      },
      onError: (_) {
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  Future<void> _updateDeliveryLocation(LatLng deliveryLocation) async {
    final routePoint = state.routePoint;
    if (routePoint == null) return;

    final routeRequestId = ++_routeRequestId;
    emit(state.copyWith(deliveryLocation: deliveryLocation, isLoading: true));

    final routePoints = await _routeService.getRoutePoints(
      start: routePoint.location,
      end: deliveryLocation,
    );

    if (isClosed || routeRequestId != _routeRequestId) return;

    emit(
      state.copyWith(
        deliveryLocation: deliveryLocation,
        routePoints: routePoints,
        isLoading: false,
      ),
    );
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
