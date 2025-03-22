import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/stadium_model.dart';
import 'package:maydon_go/src/common/service/api_service.dart';
import 'package:maydon_go/src/common/service/location_service.dart';
import 'package:maydon_go/src/common/service/marker_service.dart';

import '../../../common/router/app_routes.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocationService _locationService;

  final MarkerService _markerService;
  final Logger _logger = Logger();

  int _selectedIndex = 2;
  LocationData? _currentLocation;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  List<StadiumDetail> _stadiums = [];
  List<StadiumDetail> _searchResults = [];
  Timer? _debounce;
  Timer? _dailyUpdateTimer;

  HomeCubit({
    required LocationService locationService,
    required MarkerService markerService,
  })  : _locationService = locationService,
        _markerService = markerService,
        super(HomeInitialState()) {
    _startDailyUpdateTimer();
  }

  int get selectedIndex => _selectedIndex;

  List<StadiumDetail> get stadiums => _stadiums;

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

  void _startDailyUpdateTimer() {
    final now = DateTime.now();
    final sixAM = DateTime(now.year, now.month, now.day, 6, 0, 0);
    final initialDelay = now.isAfter(sixAM)
        ? sixAM.add(const Duration(days: 1)).difference(now)
        : sixAM.difference(now);

    _dailyUpdateTimer = Timer(initialDelay, () {
      _fetchDailyUpdates();
      _dailyUpdateTimer = Timer.periodic(const Duration(days: 1), (_) {
        _fetchDailyUpdates();
      });
    });
  }

  Future<void> _fetchDailyUpdates() async {
    _logger.d('Fetching daily updates at 6:00 AM');
    await _fetchStadiums();
    await _fetchLocation();
  }

  Future<void> initializeApp() async {
    try {
      _logger.d('Initializing app...');
      await _fetchLocation();
      await _fetchStadiums();
    } catch (e) {
      _logger.e('Error initializing app: $e');
    }
  }

  Future<void> _fetchStadiums() async {
    try {
      _logger.d('Fetching stadiums...');
      _stadiums = await ApiService().getAllStadiums();
      _stadiumStreamController.add(_stadiums);
      _searchStreamController.add(_stadiums);
      await _setMarkers();
      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: _markers,
        currentLocation: _currentLocation,
        searchResults: _searchResults,
      ));
    } catch (e) {
      _logger.e('Error fetching stadiums: $e');
    }
  }

  Future<void> _fetchLocation() async {
    try {
      _logger.d('Initializing location...');
      _currentLocation = await _locationService.getCurrentLocation();
      if (_currentLocation != null) {
        _locationStreamController.add(_currentLocation);
        await _setMarkers();
      }
    } catch (e) {
      _logger.e('Error initializing location: $e');
    }
  }

  void goToCurrentLocation() {
    if (_currentLocation != null && _mapController != null) {
      _logger.d('Going to current location...');
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            zoom: 15,
          ),
        ),
      );
    }
  }

  void onMapCreated(GoogleMapController? controller) {
    _mapController = controller;
    emit(HomeLoadedState(
      stadiums: _stadiums,
      markers: _markers,
      currentLocation: _currentLocation,
      searchResults: _searchResults,
    ));
  }

  void onMarkerTap(int stadiumId, BuildContext context) {
    context.pushNamed(AppRoutes.detailStadium, extra: stadiumId);
  }

  Future<void> _setMarkers() async {
    if (_stadiums.isEmpty || _currentLocation == null) return;
    try {
      _logger.d('Setting markers...');
      _markers = await _markerService.setMarkers(
        LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        _stadiums,
      ); // contextni olib tashladik
      _markerStreamController.add(_markers);
      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: _markers,
        currentLocation: _currentLocation,
        searchResults: _searchResults,
      ));
    } catch (e) {
      _logger.e('Error setting markers: $e');
    }
  }

  void updateIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: _markers,
        currentLocation: _currentLocation,
        searchResults: _searchResults,
      ));
    }
  }

  void moveCamera(LatLng target) {
    if (_mapController != null) {
      _logger.d('Moving camera to: $target');
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: target, zoom: 15)),
      );
    }
    _searchStreamController.add(_searchResults);
    emit(HomeLoadedState(
      stadiums: _stadiums,
      markers: _markers,
      currentLocation: _currentLocation,
      searchResults: [],
    ));
  }

  void searchStadiums(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchResults = query.isEmpty
          ? _stadiums
          : _stadiums
              .where((stadium) =>
                  stadium.name!.toLowerCase().contains(query.toLowerCase()))
              .toList()
        ..sort((a, b) => a.name!.compareTo(b.name!));
      _searchStreamController.add(_searchResults);
      emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: _markers,
        currentLocation: _currentLocation,
        searchResults: _searchResults,
      ));
    });
  }

  void clearSearchResults() {
    _searchResults.clear();
    _searchStreamController.add(_searchResults);
    emit(HomeLoadedState(
      stadiums: _stadiums,
      markers: _markers,
      currentLocation: _currentLocation,
      searchResults: _searchResults,
    ));
  }

  @override
  Future<void> close() {
    _logger.w('Closing HomeCubit...');
    _mapController?.dispose();
    _debounce?.cancel();
    _dailyUpdateTimer?.cancel();
    _stadiumStreamController.close();
    _markerStreamController.close();
    _locationStreamController.close();
    _searchStreamController.close();
    return super.close();
  }
}
