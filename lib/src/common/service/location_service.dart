import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();
  LocationData? _currentLocation;

   LocationService();

  /// Foydalanuvchining joriy lokatsiyasini olish
  Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return null;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return null;
    }

    _currentLocation = await _location.getLocation();
    return _currentLocation;
  }

  /// Lokatsiya uchun marker qo‘shish
  Future<Marker> createLocationMarker(
      LatLng position, BitmapDescriptor icon) async {
    return Marker(
      markerId: const MarkerId('current_location'),
      position: position,
      icon: icon,
      infoWindow: const InfoWindow(title: 'Your Current Location'),
    );
  }

  /// Maxsus marker uchun ikon yaratish
  Future<BitmapDescriptor> getCustomMarker(Uint8List bytes) async {
    return BitmapDescriptor.fromBytes(bytes);
  }

  static Future<double> calculateDistance(LatLng start, LatLng end) async {
    return Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000; // Kilometrga o‘tkazish
  }
}
