// States for the HomeCubit
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../common/model/stadium_model.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadedState extends HomeState {
  final List<StadiumDetail> stadiums;
  final Set<Marker> markers;
  final LocationData? currentLocation;
  final List<StadiumDetail> searchResults;

  HomeLoadedState({
    required this.stadiums,
    required this.markers,
    required this.currentLocation,
    required this.searchResults,
  });
}

class HomeLoadingState extends HomeState {}
