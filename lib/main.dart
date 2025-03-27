import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maydon_go/src/common/model/time_slot_model.dart';
import 'package:maydon_go/src/common/screens/app.dart';
import 'package:maydon_go/src/common/service/booking_service.dart';
import 'package:maydon_go/src/common/service/location_service.dart';
import 'package:maydon_go/src/common/service/marker_service.dart';
import 'package:maydon_go/src/owner/bloc/add_stadium/add_stadium_cubit.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_cubit.dart';
import 'package:maydon_go/src/user/bloc/all_stadium_cubit/all_stadium_cubit.dart';
import 'package:maydon_go/src/user/bloc/auth_cubit/auth_cubit.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_cubit.dart';
import 'package:maydon_go/src/user/bloc/booking_history/booking_history_cubit.dart';
import 'package:maydon_go/src/user/bloc/home_cubit/home_cubit.dart';
import 'package:maydon_go/src/user/bloc/locale_cubit/locale_cubit.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/user/bloc/profile_cubit/profile_cubit.dart';
import 'package:maydon_go/src/user/bloc/quizzes_cubit/quizzes_cubit.dart';
import 'package:maydon_go/src/user/bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_cubit.dart';
import 'package:maydon_go/src/user/bloc/tournament_cubit/tournament_cubit.dart';

// Notifications pluginni global o‘zgaruvchi sifatida ishlatamiz
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  // Flutter bindingni ishga tushirish
  await _initializeApp();

  // Faqat portret rejimni qo‘llab-quvvatlash
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Ilovani ishga tushirish
  runApp(_buildApp());
}

// Ilova uchun boshlang‘ich sozlamalarni amalga oshirish
Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
}

// Bildirishnomalarni sozlash
Future<void> initNotifications() async {
  const androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInitSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

// MultiBlocProvider bilan ilova qurilmasi
Widget _buildApp() {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => LocaleCubit()),
      BlocProvider(create: (_) => ProfileCubit()),
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => TournamentCubit()),
      BlocProvider(create: (_) => TeamCubit()..loadFriends()),
      BlocProvider(create: (_) => BookingCubit()),
      BlocProvider(create: (_) => BookingHistoryCubit()),
      BlocProvider(
        create: (_) => HomeCubit(
          locationService: LocationService(),
          markerService: MarkerService(),
        ),
      ),
      BlocProvider(create: (_) => SavedStadiumsCubit()),
      BlocProvider(create: (_) => StadiumCubit()),
      BlocProvider(create: (_) => MyClubCubit()),
      BlocProvider(create: (_) => QuizCubit()),
      BlocProvider(create: (_) => OwnerHomeCubit()),
      BlocProvider(create: (_) => AddStadiumCubit()),
    ],
    child: const App(),
  );
}
