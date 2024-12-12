import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maydon_go/src/style/app_icons.dart';

class MarkerService {
  // Stadionlar uchun markerlar yaratish
  Future<Set<Marker>> setMarkers(List<LatLng> stadions) async {
    BitmapDescriptor icon = await _getMarkerIcon();
    return stadions.map((stadion) {
      return Marker(
        markerId: MarkerId(stadion.toString()),
        position: stadion,
        icon: icon,
        infoWindow: InfoWindow(title: 'Stadion', snippet: 'Here is a stadion'),
      );
    }).toSet();
  }

  // Iconni olish
  Future<BitmapDescriptor> _getMarkerIcon() async {
    return await BitmapDescriptor.asset(
      ImageConfiguration(devicePixelRatio: 3.5),
      AppIcons.stadionIcon,
    );
  }

  // Location markerini yaratish
  Future<Marker> createCurrentLocationMarker(LatLng position) async {
    final ByteData byteData = await rootBundle.load(AppIcons.currentLocation);
    final bytes = byteData.buffer.asUint8List();
    final BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);

    return Marker(
      markerId: MarkerId('current_location'),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(title: 'Your Current Location'),
    );
  }
}
