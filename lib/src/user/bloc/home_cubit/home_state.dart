// States for the HomeCubit
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../common/model/stadium_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<Stadium> stadiums;
  final Set<Marker> markers;
  final LocationData? currentLocation;

  HomeLoadedState(
      {required this.stadiums, required this.markers, this.currentLocation});
}
