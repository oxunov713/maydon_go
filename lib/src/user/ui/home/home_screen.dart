import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../bloc/home_cubit/home_cubit.dart';
import '../../bloc/home_cubit/home_state.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..initializeLocation(context),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitialState) {
            return Scaffold(
              appBar: AppBar(title: const Text('Loading...')),
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is HomeLoadedState) {
            return Scaffold(
              appBar: AppBar(title: const Text('Stadiums')),
              body: Column(
                children: [
                  // Google Map to show markers
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          state.currentLocation?.latitude ?? 0.0,
                          state.currentLocation?.longitude ?? 0.0,
                        ),
                        zoom: 14,
                      ),
                      markers: state.markers,
                      onMapCreated: (controller) {
                        context.read<HomeCubit>().onMapCreated(controller);
                      },
                    ),
                  ),
                  // Bottom Navigation Bar
                  BottomNavigationBar(
                    currentIndex: context.read<HomeCubit>().selectedIndex,
                    onTap: (index) {
                      context.read<HomeCubit>().updateIndex(index);
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.location_on),
                        label: 'Locations',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.history),
                        label: 'History',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Something went wrong.')),
          );
        },
      ),
    );
  }
}
