import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/time_slot_model.dart';
import 'package:maydon_go/src/common/screens/app.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/club_service.dart';
import 'package:maydon_go/src/common/service/booking_service.dart';
import 'package:maydon_go/src/common/service/location_service.dart';
import 'package:maydon_go/src/common/service/marker_service.dart';
import 'package:maydon_go/src/owner/bloc/add_stadium/add_stadium_cubit.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_cubit.dart';
import 'package:maydon_go/src/owner/bloc/location_picker/location_picker_cubit.dart';
import 'package:maydon_go/src/user/bloc/all_stadium_cubit/all_stadium_cubit.dart';
import 'package:maydon_go/src/user/bloc/auth_cubit/auth_cubit.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_cubit.dart';
import 'package:maydon_go/src/user/bloc/booking_history/booking_history_cubit.dart';
import 'package:maydon_go/src/user/bloc/chat_cubit/chat_cubit.dart';
import 'package:maydon_go/src/user/bloc/chat_input_cubit/chat_input_cubit.dart';
import 'package:maydon_go/src/user/bloc/home_cubit/home_cubit.dart';
import 'package:maydon_go/src/user/bloc/locale_cubit/locale_cubit.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/user/bloc/profile_cubit/profile_cubit.dart';
import 'package:maydon_go/src/user/bloc/quizzes_cubit/quizzes_cubit.dart';
import 'package:maydon_go/src/user/bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import 'package:maydon_go/src/user/bloc/subscription_cubit/subscription_cubit.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_chat_cubit.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_cubit.dart';
import 'package:maydon_go/src/user/bloc/tournament_cubit/tournament_cubit.dart';
import 'package:provider/provider.dart';

import 'src/common/service/connectivity_service.dart';
import 'src/user/bloc/my_club_cubit/fab_visibility_cubit.dart';
import 'src/user/bloc/user_chats_cubit/user_chats_cubit.dart';

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
      BlocProvider(create: (_) => ProfileCubit()..loadUserData()),
      BlocProvider(create: (_) => AuthCubit()),
      BlocProvider(create: (_) => ChatCubit()),
      BlocProvider(create: (_) => TournamentCubit()),
      BlocProvider(create: (_) => TeamCubit(ClubService(ApiClient().dio))),
      BlocProvider(create: (_) => TeamChatCubit()),
      BlocProvider(create: (_) => BookingCubit()),
      BlocProvider(create: (_) => SubscriptionCubit()),
      BlocProvider(create: (_) => FabVisibilityCubit()),
      BlocProvider(create: (_) => BookingHistoryCubit()),
      BlocProvider(
        create: (_) => HomeCubit(
          locationService: LocationService(),
          markerService: MarkerService(),
        )..initializeApp(),
      ),
      BlocProvider(create: (_) => SavedStadiumsCubit()),
      BlocProvider(create: (_) => StadiumCubit()),
      BlocProvider(create: (_) => MyClubCubit()..loadData()),
      BlocProvider(create: (_) => QuizPackCubit()),
      BlocProvider(create: (_) => UserChatsCubit()),
      BlocProvider(
          create: (_) => ChatInputCubit(
                onSendTextMessage: (message) {},
                onSendVoiceMessage: (audioPath) {},
              )),
      BlocProvider(create: (_) => OwnerHomeCubit()),
      BlocProvider(create: (_) => AddStadiumCubit()..loadSubstadiums()),
      BlocProvider(create: (_) => LocationPickerCubit()..getCurrentLocation()),
      // BlocProvider(create: (_) => UserChatsCubit(),),
    ],
    child: App(),
  );
}
