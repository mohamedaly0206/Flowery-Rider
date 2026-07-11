import 'package:flowery_rider/features/order_tracking/domain/entities/map_route_args.dart';

sealed class MapIntent {}

class StartMapRouteIntent extends MapIntent {
  final MapRouteArgs routeArgs;

  StartMapRouteIntent({required this.routeArgs});
}
