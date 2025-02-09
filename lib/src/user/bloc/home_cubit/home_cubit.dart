import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../common/model/facilities_model.dart';
import '../../../common/model/location_model.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/style/app_icons.dart';
import '../../ui/home/all_stadiums_screen.dart';
import '../../ui/home/history_screen.dart';
import '../../ui/home/locations_screen.dart';
import '../../ui/home/profile_screen.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  int _selectedIndex = 2;
  final log = Logger();

  int get selectedIndex => _selectedIndex;

  List<Stadium> _stadiums = []; // Boshlang'ich qiymat
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  LocationData? currentLocation;
  final Location _location = Location();

  HomeCubit() : super(HomeInitialState()) {
    _stadiums = fakeStadiums; // Boshlang'ich ma'lumotlarni yuklash
    fetchStadiums(); // Ma'lumotlarni yuklash
  }

  List<Stadium> fakeStadiums = [
    Stadium(
      id: 1,
      name: "Olimpiya Stadioni",
      description:
          "Zamonaviy futbol maydoni, tribuna va tungi yoritish mavjud.",
      price: 150.0,
      location: LocationModel(
        address: "Olimpiya ko'chasi, 12, Toshkent",
        latitude: 41.2995,
        longitude: 69.2401,
      ),
      facilities: Facilities(
        hasBathroom: true,
        isIndoor: false,
        hasUniforms: true,
      ),
      averageRating: 4.8,
      images: [
        "https://example.com/stadium1_1.jpg",
        "https://example.com/stadium1_2.jpg",
      ],
      ratings: [5, 4, 5, 5, 4],
    ),
    Stadium(
      id: 2,
      name: "Bunyodkor Arenasi",
      description: "Bunyodkor klubi stadioni, yuqori sifatli qoplamaga ega.",
      price: 200.0,
      location: LocationModel(
        address: "Bunyodkor ko'chasi, 5, Toshkent",
        latitude: 41.3275,
        longitude: 69.2283,
      ),
      facilities: Facilities(
        hasBathroom: true,
        isIndoor: false,
        hasUniforms: false,
      ),
      averageRating: 4.5,
      images: [
        "https://example.com/stadium2_1.jpg",
        "https://example.com/stadium2_2.jpg",
      ],
      ratings: [5, 5, 4, 4, 5],
    ),
    Stadium(
      id: 3,
      name: "Paxtakor Stadioni",
      description: "O'zbekistonning eng katta stadionlaridan biri.",
      price: 180.0,
      location: LocationModel(
        address: "Paxtakor maydoni, 3, Toshkent",
        latitude: 41.3156,
        longitude: 69.2488,
      ),
      facilities: Facilities(
        hasBathroom: false,
        isIndoor: false,
        hasUniforms: true,
      ),
      averageRating: 4.7,
      images: [
        "https://example.com/stadium3_1.jpg",
        "https://example.com/stadium3_2.jpg",
      ],
      ratings: [5, 4, 4, 5, 5],
    ),
    Stadium(
      id: 4,
      name: "Navbahor Arenasi",
      description: "Namangandagi eng zamonaviy stadionlardan biri.",
      price: 130.0,
      location: LocationModel(
        address: "Navbahor ko'chasi, 8, Namangan",
        latitude: 40.9983,
        longitude: 71.6726,
      ),
      facilities: Facilities(
        hasBathroom: true,
        isIndoor: false,
        hasUniforms: false,
      ),
      averageRating: 4.2,
      images: [
        "https://example.com/stadium4_1.jpg",
        "https://example.com/stadium4_2.jpg",
      ],
      ratings: [4, 4, 5, 3, 4],
    ),
    Stadium(
      id: 5,
      name: "Dinamo Sport Majmuasi",
      description:
          "Multifunksional stadion, futbol va yengil atletika uchun mos.",
      price: 120.0,
      location: LocationModel(
        address: "Dinamo ko'chasi, 6, Samarqand",
        latitude: 39.6545,
        longitude: 66.9744,
      ),
      facilities: Facilities(
        hasBathroom: false,
        isIndoor: true,
        hasUniforms: true,
      ),
      averageRating: 4.4,
      images: [
        "https://example.com/stadium5_1.jpg",
        "https://example.com/stadium5_2.jpg",
      ],
      ratings: [5, 4, 4, 4, 5],
    ),
    Stadium(
      id: 6,
      name: "Andijon Markaziy Stadioni",
      description: "Andijondagi asosiy stadion, keng maydonga ega.",
      price: 140.0,
      location: LocationModel(
        address: "Stadion ko'chasi, 2, Andijon",
        latitude: 40.7872,
        longitude: 72.3455,
      ),
      facilities: Facilities(
        hasBathroom: true,
        isIndoor: false,
        hasUniforms: false,
      ),
      averageRating: 4.3,
      images: [
        "https://example.com/stadium6_1.jpg",
        "https://example.com/stadium6_2.jpg",
      ],
      ratings: [4, 5, 4, 3, 5],
    ),
  ];

  Future<void> fetchStadiums() async {
    if (_stadiums.isNotEmpty) {
      emit(HomeLoadedState(
          stadiums: _stadiums, markers: {}, currentLocation: currentLocation));
    }
  }

  // Update the selected tab and trigger the corresponding page
  void updateIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      emit(HomeLoadedState(
          stadiums: _stadiums,
          markers: markers,
          currentLocation: currentLocation));
    }
  }

  // Return the appropriate screen widget based on the selected index
  Widget currentPage() {
    switch (_selectedIndex) {
      case 0:
      case 1:
        return const AllStadiumsScreen();
      case 2:
        return const LocationsScreen();
      case 3:
        return HistoryScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const Scaffold();
    }
  }

  // Set markers on the map based on stadium locations
  Future<void> setMarkers() async {
    if (_stadiums.isEmpty) return; // No stadiums available

    final BitmapDescriptor icon = await _getMarkerIcon();
    markers = _stadiums.map((stadion) {
      return Marker(
        markerId: MarkerId(stadion.location.address),
        position: LatLng(stadion.location.latitude, stadion.location.longitude),
        icon: icon,
        infoWindow: InfoWindow(
          title: stadion.name,
          snippet: stadion.description,
          onTap: () async {
            await _openMapWithDirections(
                stadion.location.latitude, stadion.location.longitude);
          },
        ),
      );
    }).toSet();
    log.e(_stadiums);
    emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: markers,
        currentLocation: currentLocation));
  }

  // Open map with directions to the selected stadium
  Future<void> _openMapWithDirections(double latitude, double longitude) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;
      final selectedMap = availableMaps.first;
      selectedMap.showDirections(destination: Coords(latitude, longitude));
    } catch (e) {
      log.e(e.toString());
    }
  }

  // Load the custom marker icon
  Future<BitmapDescriptor> _getMarkerIcon() async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(devicePixelRatio: 3.5),
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

    setCurrentLocationMarker(context); // Set the current location marker
    emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: markers,
        currentLocation: currentLocation));
  }

  // Add current location marker on the map
  Future<void> setCurrentLocationMarker(BuildContext context) async {
    if (currentLocation == null) return;

    final ByteData byteData =
        await DefaultAssetBundle.of(context).load(AppIcons.currentLocation);
    final bytes = byteData.buffer.asUint8List();
    final BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);

    final LatLng position =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

    markers.add(Marker(
      markerId: const MarkerId('current_location'),
      position: position,
      icon: icon,
      infoWindow: const InfoWindow(title: 'Your Current Location'),
    ));

    emit(HomeLoadedState(
        stadiums: _stadiums,
        markers: markers,
        currentLocation: currentLocation));
  }

  // Zoom to the user's current location on the map
  void goToCurrentLocation() {
    if (currentLocation != null && mapController != null) {
      final position =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 15)));
    }
  }

  // Map controller created callback
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
