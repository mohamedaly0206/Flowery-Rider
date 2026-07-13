import 'package:equatable/equatable.dart';
import 'package:flowery_rider/modules/order_tracking/domain/entities/response/order_entity.dart';
import 'package:latlong2/latlong.dart';

enum MapRoutePointType { store, user }

class MapRoutePoint extends Equatable {
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

  @override
  List<Object?> get props => [title, address, location, type, order];
}

class MapRouteArgs extends Equatable {
  final MapRoutePoint routePoint;

  const MapRouteArgs({required this.routePoint});

  @override
  List<Object?> get props => [routePoint];
}
