import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/map_route_args.dart';
import 'package:latlong2/latlong.dart';

class MapState extends Equatable {
  final MapRoutePoint? routePoint;
  final LatLng? deliveryLocation;
  final List<LatLng> routePoints;
  final bool isLoading;
  final String errorMessage;
  List<LatLng> get visiblePoints => [
    ?routePoint?.location,
    ?deliveryLocation,
    ...routePoints,
  ];
  LatLng? get initialCenter {
    final points = visiblePoints;
    if (points.isEmpty) return null;

    final latitude =
        points
            .map((point) => point.latitude)
            .reduce((value, element) => value + element) /
        points.length;
    final longitude =
        points
            .map((point) => point.longitude)
            .reduce((value, element) => value + element) /
        points.length;

    return LatLng(latitude, longitude);
  }

  double get initialZoom => deliveryLocation == null ? 15 : 13;
  bool get shouldFitCamera => visiblePoints.length > 1;
  String get mapKeyValue =>
      visiblePoints.map((point) => point.toString()).join('|');
  String get routePointMarkerAsset {
    return switch (routePoint?.type) {
      MapRoutePointType.store => Assets.icons.storeLocation,
      MapRoutePointType.user => Assets.icons.userLocation,
      null => '',
    };
  }

  const MapState({
    this.routePoint,
    this.deliveryLocation,
    this.routePoints = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  MapState copyWith({
    MapRoutePoint? routePoint,
    LatLng? deliveryLocation,
    List<LatLng>? routePoints,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MapState(
      routePoint: routePoint ?? this.routePoint,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      routePoints: routePoints ?? this.routePoints,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    routePoint,
    deliveryLocation,
    routePoints,
    isLoading,
    errorMessage,
  ];
}
