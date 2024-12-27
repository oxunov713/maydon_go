import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:maydon_go/src/screens/home/all_stadiums_screen.dart';
import 'package:maydon_go/src/screens/home/history_screen.dart';
import 'package:maydon_go/src/screens/home/locations_screen.dart';
import 'package:maydon_go/src/screens/home/profile_screen.dart';
import 'package:maydon_go/src/screens/home/saved_stadiums.dart';

import '../data/fake_data.dart';
import '../model/stadium_model.dart';
import '../style/app_icons.dart';

class HomeProvider with ChangeNotifier {
  int _selectedIndex = 2;
  int get selectedIndex => _selectedIndex;

  // Cached stadiums list for performance optimization
  List<Stadium>? _stadions;
  List<Stadium> get stadions => _stadions ?? [];

  Set<Marker> markers = {};
  late GoogleMapController mapController;
  LocationData? currentLocation;
  final Location _location = Location();
  final LatLng initialMap = LatLng(41.2995, 69.2401);

  // Memoized method to prevent multiple calls
  Future<void> fetchStadiums() async {
    if (_stadions != null) return;  // Check if the data is already fetched

    final fetchedStadiums = FakeData.stadiumOwners.map((e) => e.stadium).toList();
    _stadions = fetchedStadiums;  // Store fetched stadiums for future use

  }

  // Update the selected tab and trigger the corresponding page
  void updateIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  // Return the appropriate screen widget based on the selected index
  Widget currentPage() {
    return switch (_selectedIndex) {
      0 => AllStadiumsScreen(),
      1 => SavedStadiumsScreen(),
      2 => LocationsScreen(),
      3 => HistoryScreen(),
      4 => ProfileScreen(),
      _ => Scaffold()
    };
  }

  // Set markers on the map based on stadium locations
  Future<void> setMarkers() async {
    if (_stadions == null || _stadions!.isEmpty) return; // No stadiums available

    final BitmapDescriptor icon = await _getMarkerIcon();
    markers = _stadions!.map((stadion) {
      return Marker(
        markerId: MarkerId(stadion.location.address),
        position: LatLng(stadion.location.latitude, stadion.location.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: stadion.name,
          snippet: stadion.description,
          onTap: () async {
            await _openMapWithDirections(stadion.location.latitude, stadion.location.longitude);
          },
        ),
      );
    }).toSet();

    notifyListeners();
  }

  // Open map with directions to the selected stadium
  Future<void> _openMapWithDirections(double latitude, double longitude) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      final selectedMap = availableMaps.first;
      selectedMap.showDirections(destination: Coords(latitude, longitude));
    } catch (e) {
      // Handle error if no map is available
    }
  }

  // Load the custom marker icon
  Future<BitmapDescriptor> _getMarkerIcon() async {
    return await BitmapDescriptor.asset(
      ImageConfiguration(devicePixelRatio: 3.5),
      AppIcons.stadionIcon,
    );
  }

  // Initialize user location and set a marker for the current location
  Future<void> initializeLocation(BuildContext context) async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    final location = await _location.getLocation();
    currentLocation = location;

    setCurrentLocationMarker(context);  // Set the current location marker
    notifyListeners();
  }

  // Map controller created callback
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Add current location marker on the map
  Future<void> setCurrentLocationMarker(BuildContext context) async {
    if (currentLocation == null) return;

    final ByteData byteData = await DefaultAssetBundle.of(context).load(AppIcons.currentLocation);
    final bytes = byteData.buffer.asUint8List();
    final BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);

    final LatLng position = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

    markers.add(Marker(
      markerId: MarkerId('current_location'),
      position: position,
      icon: icon,
      infoWindow: InfoWindow(title: 'Your Current Location'),
    ));

    notifyListeners();
  }

  // Zoom to the user's current location on the map
  void goToCurrentLocation() {
    if (currentLocation != null) {
      final position = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 15)));
    }
  }
}
