import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  BitmapDescriptor? _currentLocationIcon;
  String _locationText = "Tap the screen"; // Joylashuv matni

  @override
  void initState() {
    super.initState();
    _loadCurrentLocationIcon();
    _getCurrentLocation();
  }

  // Current Location iconini yuklash
  void _loadCurrentLocationIcon() async {
    _currentLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      AppIcons.currentLocation, // Asset fayl nomi
    );
  }

  // Foydalanuvchining hozirgi joylashuvini olish
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _selectedLocation =
          _currentLocation; // Dastlabki marker hozirgi joylashuvda
    });

    // Xaritani hozirgi joylashuvga o'tkazish
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation!, 15),
    );

    // Hozirgi joylashuv ma'lumotlarini olish
    _updateLocationText(_currentLocation!);
  }

  // Joylashuvni tanlanganda ma'lumotlarni olish
  Future<void> _onMapTap(LatLng location) async {
    setState(() {
      _selectedLocation = location; // Markerni yangi joyga ko'chirish
    });

    // Joylashuv ma'lumotlarini yangilash
    _updateLocationText(location);
  }

  // Joylashuv ma'lumotlarini yangilash
  Future<void> _updateLocationText(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _locationText = "${place.street}, ${place.locality}, ${place.country}";
      });
    } else {
      setState(() {
        _locationText = "No location details found";
      });
    }
  }

  // Joylashuvni tasdiqlash
  void _confirmLocation() async {
    if (_selectedLocation != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        Logger().e(""" 'latitude': ${_selectedLocation!.latitude},
          'longitude': ${_selectedLocation!.longitude},
          'city': ${place.locality},
          'country': ${place.country},
          'street': ${place.street},""");
        Navigator.pop(context, {
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
          'city': place.locality,
          'country': place.country,
          'street': place.street,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _confirmLocation,
            tooltip: 'Confirm Location',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              _locationText,
              maxLines: 6,
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            onTap: _onMapTap,
            initialCameraPosition: CameraPosition(
              target: LatLng(41.2995, 69.2401),
              // Dastlabki joylashuv (Toshkent)
              zoom: 12,
            ),
            markers: {
              if (_selectedLocation != null)
                Marker(
                  markerId: MarkerId('selectedLocation'),
                  position: _selectedLocation!,
                ),
              if (_currentLocation != null && _currentLocationIcon != null)
                Marker(
                    markerId: MarkerId('currentLocation'),
                    position: _currentLocation!,
                    icon: _currentLocationIcon!,
                    infoWindow: InfoWindow(title: "Current location")),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: Colors.white,
              onPressed: _getCurrentLocation,
              child: Icon(Icons.my_location,color: Colors.blue,),
              tooltip: 'Current Location',
            ),
          ),
        ],
      ),
    );
  }
}
