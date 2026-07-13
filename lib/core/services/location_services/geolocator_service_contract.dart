import 'package:geolocator/geolocator.dart';

abstract class GeolocatorServiceContract {
  Future<bool> isLocationServiceEnabled();

  Future<LocationPermission> checkPermission();

  Future<LocationPermission> requestPermission();

  Future<Position> getCurrentPosition({LocationAccuracy desiredAccuracy});

  Stream<Position> getPositionStream({
    required LocationSettings locationSettings,
  });
}
