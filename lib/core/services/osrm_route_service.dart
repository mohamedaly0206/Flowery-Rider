import 'package:dio/dio.dart';
import 'package:flowery_rider/core/values/api_endpoints.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

@lazySingleton
class OsrmRouteService {
  final Dio _dio;

  OsrmRouteService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.oSRMRouteServiceUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

  Future<List<LatLng>> getRoutePoints({
    required LatLng start,
    required LatLng end,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/route/v1/driving/'
        '${start.longitude},${start.latitude};'
        '${end.longitude},${end.latitude}',
        queryParameters: const {'overview': 'full', 'geometries': 'geojson'},
      );

      final routes = response.data?['routes'];
      if (routes is! List || routes.isEmpty) return [start, end];

      final route = routes.first;
      if (route is! Map<String, dynamic>) return [start, end];

      final geometry = route['geometry'];
      if (geometry is! Map<String, dynamic>) return [start, end];

      final coordinates = geometry['coordinates'];
      if (coordinates is! List) return [start, end];

      final routePoints = coordinates
          .whereType<List>()
          .where((coordinate) => coordinate.length >= 2)
          .map(
            (coordinate) => LatLng(
              (coordinate[1] as num).toDouble(),
              (coordinate[0] as num).toDouble(),
            ),
          )
          .toList();

      return routePoints.isEmpty ? [start, end] : routePoints;
    } catch (_) {
      return [start, end];
    }
  }
}
