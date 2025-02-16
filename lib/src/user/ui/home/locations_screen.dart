import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double floatingButtonIconSize = screenWidth * 0.1;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitialState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoadedState) {
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
                  child: Column(
                    children: [
                      SizedBox(
                        height: floatingButtonIconSize * 1.2,
                        child: SearchBar(
                          controller: _searchController,
                          hintText: "Maydonni qidirish...",
                          hintStyle: const WidgetStatePropertyAll(
                            TextStyle(
                              fontSize: 16.0,
                              color: AppColors.grey4,
                            ),
                          ),
                          backgroundColor: const WidgetStatePropertyAll(
                            AppColors.white,
                          ),
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SvgPicture.asset(
                              AppIcons.searchIcon,
                              color: AppColors.grey4,
                            ),
                          ),
                          onChanged: (query) {
                            context.read<HomeCubit>().searchStadiums(query);
                          },
                        ),
                      ),
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoadedState) {
                            final searchResults = state.searchResults;
                            if (searchResults.isNotEmpty) {
                              return Container(
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    final stadium = searchResults[index];
                                    return ListTile(
                                      title: Text(
                                        stadium.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Text("Stadionlari soni  ${stadium.stadiumCount} ta"),
                                      onTap: () {
                                        context.read<HomeCubit>().moveCamera(
                                              LatLng(
                                                stadium.location.latitude,
                                                stadium.location.longitude,
                                              ),
                                              context,
                                            );
                                        _searchController.clear();
                                        context
                                            .read<HomeCubit>()
                                            .clearSearchResults();
                                      },
                                    );
                                  },
                                ),
                              );
                            }
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
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
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                AppIcons.myLocation,
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
