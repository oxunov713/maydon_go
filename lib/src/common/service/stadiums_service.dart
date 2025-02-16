import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maydon_go/src/common/constants/config.dart';

import '../model/stadium_model.dart';

class StadiumService {
  final List<StadiumDetail> _stadiums = $fakeData;

  /// Stadionlarni olish (Fake data yoki API dan yuklab olish)
  Future<List<StadiumDetail>> fetchStadiums() async {
    return _stadiums;
  }

  /// Stadion lokatsiyasi uchun markerlar yaratish
  Set<Marker> createStadiumMarkers(
      List<StadiumDetail> stadiums, BitmapDescriptor icon) {
    return stadiums.map((stadium) {
      return Marker(
        markerId: MarkerId(stadium.location.address),
        position: LatLng(stadium.location.latitude, stadium.location.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: stadium.name,
          snippet: stadium.description,
        ),
      );
    }).toSet();
  }

  /// Masofani hisoblash (Haversine formula)
  static double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Yer radiusi (km)

    double dLat = _degreeToRadian(end.latitude - start.latitude);
    double dLon = _degreeToRadian(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreeToRadian(start.latitude)) *
            cos(_degreeToRadian(end.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Masofa km da
  }

  static double _degreeToRadian(double degree) {
    return degree * pi / 180;
  }
}
