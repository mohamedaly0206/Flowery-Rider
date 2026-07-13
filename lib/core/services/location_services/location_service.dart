import 'dart:async';
import 'package:flowery_rider/core/services/location_services/geolocator_service_contract.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocationService {
  final GeolocatorServiceContract _geolocator;

  LocationService(this._geolocator);

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return null;

    return _geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Stream<Position> getLocationStream() {
    return _locationStreamWithPermission();
  }

  Stream<Position> _locationStreamWithPermission() async* {
    final currentPosition = await getCurrentPosition();
    if (currentPosition == null) return;

    yield currentPosition;

    yield* _geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }
}
