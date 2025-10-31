part of '../common.dart';

class LocationService {
  final _location = location.Location();

  Future<bool> get isLocationServiceGranted async {
    return await _location.serviceEnabled();
  }

  Future<bool> requestLocationServicePermission() async {
    final isEnabled = await _location.serviceEnabled();
    return isEnabled ? isEnabled : await _location.requestService();
  }

  Future<location.LocationData?> getLocationData() async {
    if (!await locator<PermissionService>().isLocationGranted) {
      final isGranted = await locator<PermissionService>().requestLocationPermission();
      if (!isGranted) return null;
      await Future.delayed(OtherConstants.defaultAnimationDuration);
    }

    return await _location.getLocation();
  }
}