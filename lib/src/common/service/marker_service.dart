import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';

import '../style/app_icons.dart';
import '../model/stadium_model.dart'; // ✅ StadiumDetail modelini import qildik
import 'location_service.dart';

class MarkerService {
  // **Stadionlar uchun marker yaratish**
  Future<Set<Marker>> setMarkers(LatLng userLocation,
      List<StadiumDetail> stadiums, BuildContext context) async {
    BitmapDescriptor icon = await _getMarkerIcon();
    Set<Marker> markers = {};

    for (var stadium in stadiums) {
      // ✅ stadium.location nullable bo‘lgani uchun tekshirish kerak
      if (stadium.location == null) continue;

      final latitude = stadium.location?.latitude ?? 0.0;
      final longitude = stadium.location?.longitude ?? 0.0;

      double distance = await LocationService.calculateDistance(
        userLocation,
        LatLng(latitude, longitude),
      );

      markers.add(
        Marker(
          markerId: MarkerId(stadium.id?.toString() ?? 'unknown'), // ✅ ID nullable
          position: LatLng(latitude, longitude),
          icon: icon,
          infoWindow: InfoWindow(
            title: stadium.name ?? "Noma'lum stadion", // ✅ Name nullable
            onTap: () => context.pushNamed(
              AppRoutes.detailStadium,
              extra: stadium,
            ),
            snippet: "Sizdan ${distance.toStringAsFixed(2)} km uzoqlikda",
          ),
        ),
      );
    }
    return markers;
  }

  // **Iconni olish**
  Future<BitmapDescriptor> _getMarkerIcon() async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 3.5),
      AppIcons.stadionIcon,
    );
  }

  // **Foydalanuvchi joylashuvi uchun marker yaratish**
  Future<Marker> createCurrentLocationMarker(LatLng position) async {
    final ByteData byteData = await rootBundle.load(AppIcons.currentLocation);
    final bytes = byteData.buffer.asUint8List();
    final BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);

    return Marker(
      markerId: const MarkerId('current_location'),
      position: position,
      icon: icon,
      infoWindow: const InfoWindow(title: 'Sizning joylashuvingiz'),
    );
  }
}
