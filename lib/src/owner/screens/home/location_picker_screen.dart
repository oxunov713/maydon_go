import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maydon_go/generated/l10n.dart'; // Import generated localizations
import 'package:maydon_go/src/common/style/app_icons.dart';
import '../../../common/l10n/app_localizations.dart';
import '../../bloc/location_picker/location_picker_cubit.dart';
import '../../bloc/location_picker/location_picker_state.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    context.read<LocationPickerCubit>().getCurrentLocation();
  }

  void _confirmLocation() {
    final state = context.read<LocationPickerCubit>().state;
    if (state is LocationPickerLoaded) {
      final locationData = {
        'latitude': state.selectedLocation.latitude,
        'longitude': state.selectedLocation.longitude,
        'address': state.address,
      };
      context.pop(locationData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context); // Access translations

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n!.selectLocationTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _confirmLocation,
            tooltip: l10n.confirmLocation,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: BlocBuilder<LocationPickerCubit, LocationPickerState>(
              builder: (context, state) {
                if (state is LocationPickerLoaded) {
                  return Text(
                    state.address,
                    maxLines: 6,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    textAlign: TextAlign.center,
                  );
                }
                return Text(
                  l10n.loadingLocation,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<LocationPickerCubit, LocationPickerState>(
        builder: (context, state) {
          if (state is LocationPickerLoaded) {
            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onTap: (location) {
                    context
                        .read<LocationPickerCubit>()
                        .updateSelectedLocation(location);
                  },
                  initialCameraPosition: CameraPosition(
                    target: state.currentLocation,
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('selectedLocation'),
                      position: state.selectedLocation,
                    ),
                  },
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      context.read<LocationPickerCubit>().getCurrentLocation();
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(state.currentLocation, 15),
                      );
                    },
                    child: Icon(
                      Icons.my_location,
                      color: Colors.blue,
                    ),
                    tooltip: l10n.currentLocation,
                  ),
                ),
              ],
            );
          } else if (state is LocationPickerError) {
            return Center(child: Text(state.message.isNotEmpty ? state.message : l10n.locationError));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}