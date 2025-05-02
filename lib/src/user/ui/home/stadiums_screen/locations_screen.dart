import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/tools/price_formatter_extension.dart';

import '../../../../common/service/location_service.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_icons.dart';
import '../../../bloc/home_cubit/home_cubit.dart';
import '../../../bloc/home_cubit/home_state.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final Logger logger = Logger(); // Добавляем логгер

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    logger.d("LocationsScreen initState");
  }

  @override
  void dispose() {
    _searchController.dispose();
    logger.d("LocationsScreen dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    logger.d("LocationsScreen build");
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double floatingButtonIconSize = screenWidth * 0.1;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen: (previous, current) {
          if (previous is! HomeLoadedState || current is! HomeLoadedState) {
            return true;
          }
          final shouldRebuild = previous.markers != current.markers ||
              previous.stadiums != current.stadiums ||
              previous.currentLocation != current.currentLocation;

          return shouldRebuild;
        },
        builder: (context, state) {
          if (state is HomeInitialState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeLoadedState) {
            final currentLocation = state.currentLocation;

            return Stack(
              children: [
                SizedBox.expand(
                  child: currentLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          key: const PageStorageKey("googleMapKey"),
                          onMapCreated: (controller) {
                            logger.d("GoogleMap onMapCreated");
                            final cubit = context.read<HomeCubit>();
                            cubit.onMapCreated(controller);
                          },
                          compassEnabled: true,
                          trafficEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation.latitude!,
                                currentLocation.longitude!),
                            zoom: 13,
                          ),
                          myLocationEnabled: true,
                          markers: state.markers.map((marker) {
                            final stadium = state.stadiums.firstWhere((s) =>
                                s.id.toString() == marker.markerId.value);
                            return marker.copyWith(
                                infoWindowParam: InfoWindow(
                              title: stadium.name ?? "Noma'lum stadion",
                              snippet:
                                  "Soati: ${stadium.price?.formatWithSpace()} so'm",
                              onTap: () {
                                final stadiumId =
                                    int.parse(marker.markerId.value);
                                context
                                    .read<HomeCubit>()
                                    .onMarkerTap(stadiumId, context);
                              },
                            ));
                          }).toSet(),
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
                                        stadium.name ?? "Name is empty",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Text(
                                          "Stadionlari soni  ${stadium.fields?.length} ta"),
                                      onTap: () {
                                        context.read<HomeCubit>().moveCamera(
                                              LatLng(
                                                stadium.location!.latitude ?? 0,
                                                stadium.location!.longitude ??
                                                    0,
                                              ),
                                            );
                                        _searchController.clear();
                                        FocusScope.of(context).unfocus();
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
            FocusScope.of(context).unfocus();
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
