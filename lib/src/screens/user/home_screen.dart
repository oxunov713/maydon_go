import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:maydon_go/src/screens/user/chat_screen.dart';
import 'package:maydon_go/src/screens/user/help_screen.dart';
import 'package:maydon_go/src/screens/user/history_screen.dart';
import 'package:maydon_go/src/screens/user/profile_screen.dart';
import 'package:maydon_go/src/screens/user/settings_screen.dart';

import '../../style/app_colors.dart';
import '../../style/app_icons.dart';
import '../../widgets/custom_list_tile.dart';
import '../../widgets/home_menu_widget.dart';
import 'all_stadiums_screen.dart';
import 'favourites_screen.dart';
import 'top_ratings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  LocationData? _currentLocation;
  final Location _location = Location();
  final LatLng initialMap = LatLng(41.2995, 69.2401);
  List<LatLng> stadions = [
    const LatLng(41.2995, 69.2401),
    const LatLng(41.2985, 69.2501),
    const LatLng(41.2898, 69.2401),
    const LatLng(41.2795, 69.2411),
    const LatLng(41.2995, 69.2421),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Markerlarni saqlash uchun Set
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _setMarkers(); // Markerlarni o'rnatish
  }

  // Markerlarni o'rnatish
  void _setMarkers() async {
    BitmapDescriptor icon = await _getMarkerIcon();
    setState(() {
      _markers = stadions.map((stadion) {
        return Marker(
          markerId: MarkerId(stadion.toString()),
          position: stadion,
          icon: icon,
          infoWindow: InfoWindow(
            title: 'Stadion',
            snippet: 'Here is a stadion',
          ),
        );
      }).toSet();
    });
  }

  // Asset iconini oladigan method
  Future<BitmapDescriptor> _getMarkerIcon() async {
    return await BitmapDescriptor.asset(
      ImageConfiguration(devicePixelRatio: 3.5),
      AppIcons.stadionIcon,
    );
  }

  // Locationni aniqlash
  void _initializeLocation() async {
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
    setState(() {
      _currentLocation = location;
    });
    _setCurrentLocationMarker(); // Current location markerini o'rnatish
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

// CurrentLocation markerini yaratish
  void _setCurrentLocationMarker() async {
    // Load the icon as a byte array
    final ByteData byteData =
        await DefaultAssetBundle.of(context).load(AppIcons.currentLocation);
    final bytes = byteData.buffer.asUint8List();

    // Create a BitmapDescriptor from the byte data
    final BitmapDescriptor icon = BitmapDescriptor.fromBytes(bytes);
    if (_currentLocation != null) {
      final LatLng position = LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      );

      setState(() {
        _markers.add(Marker(
          markerId: MarkerId('current_location'),
          position: position,
          icon: icon,
          infoWindow: InfoWindow(
            title: 'Your Current Location',
          ),
        ));
      });
    }
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null) {
      final position = LatLng(
        _currentLocation!.latitude!,
        _currentLocation!.longitude!,
      );
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double floatingButtonOuterRadius = screenWidth * 0.115;
    double floatingButtonInnerRadius = screenWidth * 0.10;
    double floatingButtonIconSize = screenWidth * 0.1;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage(AppIcons.avatarImage),
                ),
                accountEmail: Text("+998900050713"),
                accountName: Text(
                  "Azizbek Oxunov",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                decoration: BoxDecoration(
                  color: AppColors.green,
                ),
              ),
              customListTile(
                context: context,
                text: "Barcha maydonlar",
                icon: AppIcons.stadionsIcon,
                goToScreen: AllStadiumsScreen(),
              ),
              customListTile(
                context: context,
                text: "Top Reyting",
                icon: AppIcons.topRatingsIcon,
                goToScreen: TopRatings(),
              ),
              ListTile(
                leading: Icon(Icons.bookmark_border_outlined,color: AppColors.main,),
                title: Text(
                  "Saqlanganlar",
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavouritesScreen(),
                  ),
                ),
              ),
              customListTile(
                  context: context,
                  text: "Profil",
                  icon: AppIcons.profileIcon,
                  goToScreen: ProfileScreen()),
              customListTile(
                context: context,
                text: "Tarix",
                icon: AppIcons.historyIcon,
                goToScreen: HistoryScreen(),
              ),
              customListTile(
                context: context,
                text: "Sozlamalar",
                icon: AppIcons.settingsIcon,
                goToScreen: SettingsScreen(),
              ),
              customListTile(
                context: context,
                text: "Yordam",
                icon: AppIcons.faqIcon,
                goToScreen: HelpScreen(),
              ),
              customListTile(
                context: context,
                text: "Xabarlar",
                icon: AppIcons.chatIcon,
                goToScreen: ChatScreen(),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.08),
              child: SizedBox.expand(
                child: _currentLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: initialMap,
                          zoom: 13,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        markers: _markers, // Markerlarni xaritada ko'rsatish
                      ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildIconButton(
                        iconPath: AppIcons.menuIcon,
                        isLeftAligned: false,
                        scaffoldKey: _scaffoldKey),
                    buildIconButton(
                        iconPath: AppIcons.searchIcon,
                        isLeftAligned: true,
                        scaffoldKey: _scaffoldKey),
                  ],
                ),
                // Bottom green bar
                Container(
                  height: screenHeight * 0.08,
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.03),
          child: InkWell(
            onTap: _goToCurrentLocation,
            child: CircleAvatar(
              radius: floatingButtonOuterRadius,
              backgroundColor: AppColors.white,
              child: CircleAvatar(
                radius: floatingButtonInnerRadius,
                backgroundColor: AppColors.green,
                child: SvgPicture.asset(
                  AppIcons.locationIcon,
                  height: floatingButtonIconSize,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
