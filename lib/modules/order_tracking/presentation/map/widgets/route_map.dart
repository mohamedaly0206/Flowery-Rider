import 'package:flowery_rider/core/theme/app_colors.dart';
import 'package:flowery_rider/core/values/assets.gen.dart';
import 'package:flowery_rider/modules/order_tracking/presentation/map/view_model/state/map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';

class RouteMap extends StatelessWidget {
  final MapState state;

  const RouteMap({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final routePoint = state.routePoint;
    final initialCenter = state.initialCenter;

    if (routePoint == null || initialCenter == null) {
      return const SizedBox.shrink();
    }

    return FlutterMap(
      key: ValueKey(state.mapKeyValue),
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: state.initialZoom,
        initialCameraFit: state.shouldFitCamera
            ? CameraFit.coordinates(
                coordinates: state.visiblePoints,
                padding: const EdgeInsets.all(48),
              )
            : null,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.flowery.rider',
        ),
        if (state.routePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: state.routePoints,
                color: AppColors.primaryColor,
                strokeWidth: 4,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            Marker(
              width: 72,
              height: 72,
              point: routePoint.location,
              child: SvgPicture.asset(state.routePointMarkerAsset),
            ),
            if (state.deliveryLocation != null)
              Marker(
                width: 72,
                height: 72,
                point: state.deliveryLocation!,
                child: SvgPicture.asset(Assets.icons.deliveryLocation),
              ),
          ],
        ),
      ],
    );
  }
}
