// States for the HomeCubit
import 'package:equatable/equatable.dart';
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
  final GoogleMapController? googleMap;

  HomeLoadedState({
    required this.stadiums,
    required this.markers,
    required this.currentLocation,
    required this.searchResults,
    this.googleMap,
  });

  HomeLoadedState copyWith({
    List<StadiumDetail>? stadiums,
    Set<Marker>? markers,
    LocationData? currentLocation,
    List<StadiumDetail>? searchResults,
    GoogleMapController? googleMap,
  }) {
    return HomeLoadedState(
      stadiums: stadiums ?? this.stadiums,
      markers: markers ?? this.markers,
      currentLocation: currentLocation ?? this.currentLocation,
      searchResults: searchResults ?? this.searchResults,
      googleMap: googleMap ?? this.googleMap,
    );
  }
}

class HomeLoadingState extends HomeState {}
