import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/service/marker_service.dart';
import 'package:maydon_go/src/user/ui/home/my_club_screen.dart';

import '../../../common/model/stadium_model.dart';
import '../../../common/service/location_service.dart';
import '../../../common/service/stadiums_service.dart';
import '../../ui/home/all_stadiums_screen.dart';
import '../../ui/home/locations_screen.dart';
import '../../ui/home/profile_screen.dart';
import '../../ui/home/saved_stadiums.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocationService _locationService;
  final StadiumService _stadiumService;
  final MarkerService _markerService;

  int selectedIndex = 2;
  LocationData? currentLocation;
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  List<StadiumDetail> _stadiums = [];
  List<StadiumDetail> _searchResults = [];
  final logger = Logger();
  Timer? _debounce;

  // 📌 **STREAMLAR**
  final StreamController<List<StadiumDetail>> _stadiumStreamController =
      StreamController.broadcast();
  final StreamController<Set<Marker>> _markerStreamController =
      StreamController.broadcast();
  final StreamController<LocationData?> _locationStreamController =
      StreamController.broadcast();
  final StreamController<List<StadiumDetail>> _searchStreamController =
      StreamController.broadcast();

  Stream<List<StadiumDetail>> get stadiumStream =>
      _stadiumStreamController.stream;

  Stream<Set<Marker>> get markerStream => _markerStreamController.stream;

  Stream<LocationData?> get locationStream => _locationStreamController.stream;

  Stream<List<StadiumDetail>> get searchStream =>
      _searchStreamController.stream;

  HomeCubit(this._locationService, this._stadiumService, this._markerService)
      : super(HomeInitialState());

  Future<void> initializeApp(BuildContext context) async {
    try {
      logger.d('Initializing app...');
      await initializeLocation(context);
      await fetchStadiums(context);
    } catch (e) {
      logger.e('Error initializing app: $e');
    }
  }

  Widget currentPage() {
    switch (selectedIndex) {
      case 0:
        return const AllStadiumsScreen();
      case 1:
        return const SavedStadiums();
      case 2:
        return const LocationsScreen();
      case 3:
        return  MyClubScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const LocationsScreen();
    }
  }

  Future<void> fetchStadiums(BuildContext context) async {
    try {
      logger.d('Fetching stadiums...');
      _stadiums = await _stadiumService.fetchStadiums();
      _stadiumStreamController.add(_stadiums);
      _searchStreamController
          .add(_stadiums); // ✅ Qidiruv uchun ham boshlang‘ich holat
      await setMarkers(context);
      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: markers,
        currentLocation: currentLocation,
        searchResults: _searchResults,
      ));
    } catch (e) {
      logger.e('Error fetching stadiums: $e');
    }
  }

  Future<void> initializeLocation(BuildContext context) async {
    try {
      logger.d('Initializing location...');
      currentLocation = await _locationService.getCurrentLocation();
      if (currentLocation != null) {
        _locationStreamController.add(currentLocation);
        await setCurrentLocationMarker();
        await setMarkers(context);
      }
    } catch (e) {
      logger.e('Error initializing location: $e');
    }
  }

  Future<void> setCurrentLocationMarker() async {
    if (currentLocation == null) return;

    final LatLng position = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    final Marker locationMarker =
        await _markerService.createCurrentLocationMarker(position);

    markers
        .removeWhere((marker) => marker.markerId.value == 'current_location');
    markers.add(locationMarker);
    _markerStreamController.add(markers);

    emit(HomeLoadedState(
      stadiums: _stadiums,
      markers: markers,
      currentLocation: currentLocation,
      searchResults: _searchResults,
    ));
  }

  void goToCurrentLocation() {
    if (currentLocation != null && mapController != null) {
      logger.d('Going to current location...');
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    logger.d('Map created...');
    mapController = controller;
  }

  Future<void> setMarkers(BuildContext context) async {
    if (_stadiums.isEmpty || currentLocation == null) return;
    try {
      logger.d('Setting markers...');
      Set<Marker> newMarkers = await _markerService.setMarkers(
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          _stadiums,
          context);
      markers = {...markers, ...newMarkers};
      _markerStreamController.add(markers);

      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: markers,
        currentLocation: currentLocation,
        searchResults: _searchResults,
      ));
    } catch (e) {
      logger.e('Error setting markers: $e');
    }
  }

  void updateIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: markers,
        currentLocation: currentLocation,
        searchResults: _searchResults,
      ));
    }
  }

  void moveCamera(LatLng target, BuildContext context) {
    FocusScope.of(context).unfocus(); // 📌 Klaviaturani yopish
    if (mapController != null) {
      logger.d('Moving camera to: $target');
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 15),
        ),
      );
    }

    _searchStreamController.add(_searchResults);

    emit(HomeLoadedState(
      stadiums: _stadiums,
      markers: markers,
      currentLocation: currentLocation,
      searchResults: [], // 📌 Search natijalari bo‘sh bo‘ladi
    ));
  }

  // 📌 **QIDIRISH FUNKSIYASI**
  void searchStadiums(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel(); // ⏳ Oldingi qidiruvni bekor qilish

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        _searchResults = _stadiums; // ✅ Bo‘sh bo‘lsa, hamma stadionlar
      } else {
        _searchResults = _stadiums
            .where((stadium) =>
            stadium.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      // Sort by name
      _searchResults.sort((a, b) => a.name!.compareTo(b.name!));

      _searchStreamController.add(_searchResults);

      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: markers,
        currentLocation: currentLocation,
        searchResults: _searchResults,
      ));
    });
  }

  void clearSearchResults() {
    _searchResults.clear(); // 🔥 Qidiruv natijalari tozalanadi
    _searchStreamController.add(_searchResults);

    emit(HomeLoadedState(
      stadiums: _stadiums,
      markers: markers,
      currentLocation: currentLocation,
      searchResults: _searchResults, // ✅ Bo‘sh holatda qaytadi
    ));
  }

  @override
  Future<void> close() {
    logger.w('Closing HomeCubit...');
    mapController?.dispose();
    _debounce?.cancel();
    _stadiumStreamController.close();
    _markerStreamController.close();
    _locationStreamController.close();
    _searchStreamController.close();
    return super.close();
  }
}
