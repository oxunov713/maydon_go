import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationPickerState {}

class LocationPickerInitial extends LocationPickerState {}

class LocationPickerLoading extends LocationPickerState {}

class LocationPickerLoaded extends LocationPickerState {
  final LatLng currentLocation;
  final LatLng selectedLocation;
  final String address;
  final String country;
  final String city;
  final String street;
  final String postalCode;
  final String administrativeArea;

  LocationPickerLoaded({
    required this.currentLocation,
    required this.selectedLocation,
    required this.address,
    this.country = '',
    this.city = '',
    this.street = '',
    this.postalCode = '',
    this.administrativeArea = '',
  });

  LocationPickerLoaded copyWith({
    LatLng? currentLocation,
    LatLng? selectedLocation,
    String? address,
    String? country,
    String? city,
    String? street,
    String? postalCode,
    String? administrativeArea,
  }) {
    return LocationPickerLoaded(
      currentLocation: currentLocation ?? this.currentLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      address: address ?? this.address,
      country: country ?? this.country,
      city: city ?? this.city,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      administrativeArea: administrativeArea ?? this.administrativeArea,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': selectedLocation.latitude,
      'longitude': selectedLocation.longitude,
      'address': address,
      'country': country,
      'city': city,
      'street': street,
      'postalCode': postalCode,
      'administrativeArea': administrativeArea,
    };
  }
}

class LocationPickerError extends LocationPickerState {
  final String message;
  final bool isPermissionError;

  LocationPickerError(this.message, {this.isPermissionError = false});
}