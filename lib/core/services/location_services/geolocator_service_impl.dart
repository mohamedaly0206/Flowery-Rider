import 'package:flowery_rider/core/services/location_services/geolocator_service_contract.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: GeolocatorServiceContract)
class GeolocatorServiceImpl implements GeolocatorServiceContract {
  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  @override
  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  @override
  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.high,
  }) {
    return Geolocator.getCurrentPosition(desiredAccuracy: desiredAccuracy);
  }

  @override
  Stream<Position> getPositionStream({
    required LocationSettings locationSettings,
  }) {
    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}
