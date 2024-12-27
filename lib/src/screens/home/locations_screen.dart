import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maydon_go/src/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../style/app_colors.dart';
import '../../style/app_icons.dart';

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
      body: Stack(
        children: [
          SizedBox.expand(
            child: Provider.of<HomeProvider>(context, listen: true)
                        .currentLocation ==
                    null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated:
                        Provider.of<HomeProvider>(context, listen: false)
                            .onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: Provider.of<HomeProvider>(context).initialMap,
                      zoom: 13,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: Provider.of<HomeProvider>(context, listen: true)
                        .markers, // Markerlarni xaritada ko'rsatish
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
                hintStyle: WidgetStateTextStyle.resolveWith(
                  (states) => TextStyle(
                    fontSize: 16.0,
                    color: AppColors.grey4,
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(AppColors.white),
                leading: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: SvgPicture.asset(
                    AppIcons.searchIcon,
                    color: AppColors.grey4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: screenHeight / 5 / 1.8),
        child: InkWell(
          onTap: Provider.of<HomeProvider>(context).goToCurrentLocation,
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            radius: floatingButtonIconSize / 2,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child:Icon(AppIcons.myLocation,color: AppColors.blue,)
            ),
          ),
        ),
      ),
    );
  }
}
