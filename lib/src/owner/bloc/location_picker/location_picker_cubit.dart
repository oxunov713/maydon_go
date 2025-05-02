import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import 'location_picker_state.dart';

class LocationPickerCubit extends Cubit<LocationPickerState> {
  LocationPickerCubit() : super(LocationPickerInitial());
  final Logger _logger = Logger();

  Future<void> getCurrentLocation() async {
    try {
      emit(LocationPickerLoading());

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationPickerError('Location services are disabled'));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationPickerError('Location permissions are denied'));
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      final currentLocation = LatLng(position.latitude, position.longitude);

      final placemarks = await placemarkFromCoordinates(
        currentLocation.latitude,
        currentLocation.longitude,
      );

      emit(LocationPickerLoaded(
        currentLocation: currentLocation,
        selectedLocation: currentLocation,
        address: _formatAddress(placemarks.first),
      ));
    } catch (e) {
      _logger.e('Location error: $e');
      emit(LocationPickerError('Failed to get location'));
    }
  }

  Future<void> updateSelectedLocation(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        emit(LocationPickerLoaded(
          currentLocation: location,
          selectedLocation: location,
          address: _formatAddress(place),
          country: place.country ?? '',
          city: place.locality ?? place.subAdministrativeArea ?? '',
          street: place.street ?? '',
          postalCode: place.postalCode ?? '',
          administrativeArea: place.administrativeArea ?? '',
        ));
      }
    } catch (e) {
      emit(LocationPickerError('Failed to get address details: $e'));
    }
  }

  String _formatAddress(Placemark place) {
    return "${place.street}, ${place.locality}, ${place.country}";
  }
}
