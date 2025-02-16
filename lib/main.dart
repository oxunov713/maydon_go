import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/user/bloc/all_stadium_cubit/all_stadium_cubit.dart';
import 'package:maydon_go/src/user/bloc/auth_cubit/auth_cubit.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_cubit.dart';
import 'package:maydon_go/src/user/bloc/home_cubit/home_cubit.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/user/bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import 'package:maydon_go/src/common/service/location_service.dart';
import 'package:maydon_go/src/common/service/stadiums_service.dart';
import 'package:maydon_go/src/common/service/marker_service.dart';

import 'src/common/screens/app.dart';
import 'src/user/bloc/locale_cubit/locale_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    final locationService = LocationService();
    final stadiumService = StadiumService();
    final markerService = MarkerService();

    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LocaleCubit()),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => BookingCubit()),
          BlocProvider(
            create: (_) =>
                HomeCubit(locationService, stadiumService, markerService),
          ),
          BlocProvider(create: (_) => SavedStadiumsCubit()),
          BlocProvider(create: (_) => StadiumCubit()),
          BlocProvider(create: (_) => MyClubCubit()),
        ],
        child: const App(),
      ),
    );
  });
}
