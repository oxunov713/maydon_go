import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maydon_go/src/common/service/api_service.dart';

import '../model/stadium_model.dart';

class StadiumService {
  late List<StadiumDetail> _stadiums;

  Future<List<StadiumDetail>> fetchStadiums() async {
    _stadiums = await ApiService().getAllStadiums(size: 200);
    return _stadiums;
  }

  /// Stadion lokatsiyasi uchun markerlar yaratish
  Set<Marker> createStadiumMarkers(
      List<StadiumDetail> stadiums, BitmapDescriptor icon) {
    return stadiums
        .map((stadium) {
          final location = stadium.location;
          if (location == null)
            return null; // ✅ location null bo‘lsa, marker qo‘shmaymiz

          return Marker(
            markerId: MarkerId(location.city ?? "Unknown"), // ✅ city nullable
            position:
                LatLng(location.latitude ?? 0.0, location.longitude ?? 0.0),
            icon: icon,
            infoWindow: InfoWindow(
              title: stadium.name ?? "Noma'lum stadion", // ✅ name nullable
              snippet: stadium.description ??
                  "Tavsif mavjud emas", // ✅ description nullable
            ),
          );
        })
        .whereType<Marker>()
        .toSet(); // ✅ Null markerlarni chiqarib tashlash
  }

  /// Masofani hisoblash (Haversine formula)
  static double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Yer radiusi (km)

    double dLat =
        _degreeToRadian((end.latitude ?? 0.0) - (start.latitude ?? 0.0));
    double dLon =
        _degreeToRadian((end.longitude ?? 0.0) - (start.longitude ?? 0.0));

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(start.latitude ?? 0.0)) *
            cos(_degreeToRadian(end.latitude ?? 0.0)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Masofa km da
  }

  static double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }
}
