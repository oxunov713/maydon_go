import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../bloc/home_cubit/home_cubit.dart';
import '../../bloc/home_cubit/home_state.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double floatingButtonIconSize = screenWidth * 0.1;

    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitialState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoadedState) {
            // Get the currentLocation and markers from the state
            var currentLocation = state.currentLocation;
            var markers = state.markers;

            return Stack(
              children: [
                SizedBox.expand(
                  child: currentLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          onMapCreated: (controller) {
                            context.read<HomeCubit>().onMapCreated(controller);
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation.latitude!,
                                currentLocation.longitude!),
                            zoom: 13,
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: markers, // Markers from the cubit state
                        ),
                ),
                Positioned(
                  top: 15,
                  left: 10,
                  right: 10,
                  child: SizedBox(
                    height: floatingButtonIconSize * 1.2,
                    child: SearchBar(
                      hintText: "Maydonni qidirish...",
                      hintStyle: WidgetStatePropertyAll(
                        TextStyle(
                          fontSize: 16.0,
                          color: AppColors.grey4,
                        ),
                      ),
                      backgroundColor: WidgetStatePropertyAll(
                        AppColors.white,
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(
                          AppIcons.searchIcon,
                          color: AppColors.grey4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: screenHeight / 5 / 1.8),
        child: InkWell(
          onTap: () {
            context.read<HomeCubit>().goToCurrentLocation();
          },
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            radius: floatingButtonIconSize / 2,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(
                AppIcons.myLocation,
                color: AppColors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}