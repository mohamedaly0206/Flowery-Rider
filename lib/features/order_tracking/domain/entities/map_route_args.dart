import 'package:flowery_rider/features/order_tracking/domain/entities/response/order_entity.dart';
import 'package:latlong2/latlong.dart';

enum MapRoutePointType { store, user }

class MapRoutePoint {
  final String title;
  final String address;
  final LatLng location;
  final MapRoutePointType type;
  final OrderEntity order;

  const MapRoutePoint({
    required this.title,
    required this.address,
    required this.location,
    required this.type,
    required this.order,
  });
}

class MapRouteArgs {
  final MapRoutePoint routePoint;

  const MapRouteArgs({required this.routePoint});
}
