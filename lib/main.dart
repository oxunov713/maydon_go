import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/common/model/time_slot_model.dart';
import 'src/common/screens/app.dart';
import 'src/common/service/hive_service.dart';
import 'src/common/service/location_service.dart';
import 'src/common/service/marker_service.dart';
import 'src/owner/bloc/add_stadium/add_stadium_cubit.dart';
import 'src/owner/bloc/home/owner_home_cubit.dart';
import 'src/user/bloc/all_stadium_cubit/all_stadium_cubit.dart';
import 'src/user/bloc/auth_cubit/auth_cubit.dart';
import 'src/user/bloc/booking_cubit/booking_cubit.dart';
import 'src/user/bloc/home_cubit/home_cubit.dart';
import 'src/user/bloc/locale_cubit/locale_cubit.dart';
import 'src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'src/user/bloc/quizzes_cubit/quizzes_cubit.dart';
import 'src/user/bloc/saved_stadium_cubit/saved_stadium_cubit.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Hive.initFlutter();
  Hive.registerAdapter(TimeSlotAdapter());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LocaleCubit()),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => BookingCubit()),
          BlocProvider(
              create: (_) => HomeCubit(
                  locationService: LocationService(),
                  markerService: MarkerService())),
          BlocProvider(create: (_) => SavedStadiumsCubit()),
          BlocProvider(create: (_) => StadiumCubit()),
          BlocProvider(create: (_) => MyClubCubit()),
          BlocProvider(create: (_) => QuizzesCubit()),
          BlocProvider(create: (_) => OwnerHomeCubit()),
          BlocProvider(create: (_) => AddStadiumCubit()),
        ],
        child: const App(),
      ),
    );
  });
}

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidInitSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}
