import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/quiz_model.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import 'package:maydon_go/src/common/screens/app.dart';
import 'package:maydon_go/src/owner/screens/home/substadium_screen.dart';
import 'package:maydon_go/src/user/ui/home/profile_screen/donation_page.dart';
import 'package:maydon_go/src/user/ui/home/home_screen/messages_screen.dart';
import 'package:maydon_go/src/user/ui/home/profile_screen/quiz_detail_page.dart';
import 'package:maydon_go/src/user/ui/home/home_screen/story_screen.dart';
import 'package:maydon_go/src/user/ui/home/home_screen/team_chat_screen.dart';
import 'package:maydon_go/src/user/ui/home/profile_screen/tournament_page.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../owner/bloc/add_stadium/add_stadium_cubit.dart';
import '../../owner/bloc/home/owner_home_cubit.dart';
import '../../owner/screens/home/add_stadium_screen.dart';
import '../../owner/screens/home/location_picker_screen.dart';
import '../../owner/screens/home/owner_dashboard.dart';
import '../../user/bloc/all_stadium_cubit/all_stadium_cubit.dart';
import '../../user/bloc/auth_cubit/auth_cubit.dart';
import '../../user/bloc/booking_cubit/booking_cubit.dart';
import '../../user/bloc/home_cubit/home_cubit.dart';
import '../../user/bloc/locale_cubit/locale_cubit.dart';
import '../../user/bloc/my_club_cubit/my_club_cubit.dart';
import '../../user/bloc/quizzes_cubit/quizzes_cubit.dart';
import '../../user/bloc/saved_stadium_cubit/saved_stadium_cubit.dart';
import '../../user/ui/home/profile_screen/about_app.dart';
import '../../user/ui/home/stadiums_screen/all_stadiums_screen.dart';
import '../../user/ui/home/home_screen/chat_screen.dart';
import '../../user/ui/home/home_screen/club_detail_screen.dart';
import '../../user/ui/home/home_screen/club_teammates.dart';
import '../../user/ui/home/profile_screen/history_screen.dart';
import '../../user/ui/home/home_screen/home_screen.dart';
import '../../user/ui/home/stadiums_screen/locations_screen.dart';

import '../../user/ui/home/home_screen/my_club_screen.dart';
import '../../user/ui/home/profile_screen/notification_screen.dart';
import '../../user/ui/home/profile_screen/profile_screen.dart';
import '../../user/ui/home/profile_screen/profile_view_screen.dart';
import '../../user/ui/home/profile_screen/quizzes_screen.dart';
import '../../user/ui/home/stadiums_screen/saved_stadiums.dart';
import '../../user/ui/home/stadiums_screen/stadium_detail.dart';
import '../../user/ui/home/profile_screen/subscription_screen.dart';
import '../../user/ui/home/home_screen/user_coins_ranking.dart';
import '../auth/log_in_screen.dart';
import '../auth/sign_up_screen.dart';
import '../model/main_model.dart';
import '../model/stadium_model.dart';
import '../screens/choose_language_screens.dart';
import '../../owner/screens/home/owner_subscription.dart';
import '../screens/role_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/welcome_screen.dart';
import '../../user/ui/home/profile_screen/sms_verification.dart';
import '../style/app_icons.dart';
import 'app_routes.dart';

class AppRouter {
  static get goRouter => _router;
}

final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        name: AppRoutes.splash,
        builder: (context, state) => ChooseLanguageScreens(),
        routes: [
          GoRoute(
            path: "lan",
            name: AppRoutes.chooseLanguage,
            builder: (context, state) => const ChooseLanguageScreens(),
          ),
          GoRoute(
            path: "welcome",
            name: AppRoutes.welcome,
            builder: (context, state) => WelcomeScreen(),
          ),
          GoRoute(
              path: "role",
              name: AppRoutes.role,
              builder: (context, state) => const RoleScreen(),
              routes: [
                GoRoute(
                    path: "userSignUp",
                    name: AppRoutes.signUp,
                    builder: (context, state) => const SignUpScreen(),
                    routes: [
                      GoRoute(
                          path: "home",
                          name: AppRoutes.home,
                          builder: (context, state) => const HomeScreen(),
                          routes: [
                            GoRoute(
                              path: "stadiums",
                              name: AppRoutes.allStadiums,
                              builder: (context, state) =>
                                  const AllStadiumsScreen(),
                            ),
                            GoRoute(
                              path: "detail",
                              name: AppRoutes.detailStadium,
                              builder: (context, state) {
                                final stadiumId = state.extra as int;
                                return StadiumDetailScreen(
                                    stadiumId: stadiumId);
                              },
                            ),
                            GoRoute(
                              path: "saved",
                              name: AppRoutes.saved,
                              builder: (context, state) =>
                                  const SavedStadiums(),
                            ),
                            GoRoute(
                              path: "myClub",
                              name: AppRoutes.myClub,
                              builder: (context, state) => MyClubScreen(),
                            ),
                            GoRoute(
                              path: "coinsRanking",
                              name: AppRoutes.coinsRanking,
                              builder: (context, state) => UserCoinsRanking(),
                            ),
                            GoRoute(
                              path: "story_screen",
                              name: AppRoutes.story,
                              builder: (context, state) {
                                final extra =
                                    state.extra as Map<String, dynamic>;
                                final mediaUrls = extra['url'] as List<String>;
                                final mediaTypes =
                                    extra['types'] as List<String>;
                                final user = extra['user'] as UserModel;
                                return StoryScreen(
                                    mediaUrls: mediaUrls,
                                    mediaTypes: mediaTypes,
                                    user: user);
                              },
                            ),
                            GoRoute(
                              path: "chat",
                              name: AppRoutes.chat,
                              builder: (context, state) {
                                final extra =
                                    state.extra as Map<String, dynamic>;
                                final currentUser =
                                    extra['currentUser'] as types.User;
                                final receiverUser =
                                    extra['receiverUser'] as types.User;
                                final id = extra['chatId'] as int;
                                return ChatScreen(
                                  chatId: id,
                                  currentUser: currentUser,
                                  receiverUser: receiverUser,
                                );
                              },
                            ),
                            GoRoute(
                              path: "teamChat",
                              name: AppRoutes.teamChat,
                              builder: (context, state) {
                                return TeamChatScreen(
                                  teamLogo: "",
                                  teamName: "Real Madrid",
                                );
                              },
                            ),
                            GoRoute(
                              path: "messages",
                              name: AppRoutes.messages,
                              builder: (context, state) => MessagesScreen(),
                            ),
                            GoRoute(
                              path: "clubDetail",
                              name: AppRoutes.clubDetail,
                              builder: (context, state) =>
                                  const ClubDetailScreen(),
                            ),
                            GoRoute(
                              path: "clubTeammates",
                              name: AppRoutes.clubTeammates,
                              builder: (context, state) =>
                                  const ClubTeammates(),
                            ),
                            GoRoute(
                                path: "profile",
                                name: AppRoutes.profile,
                                builder: (context, state) =>
                                    const ProfileScreen(),
                                routes: [
                                  GoRoute(
                                    path: "profileView",
                                    name: AppRoutes.profileView,
                                    builder: (context, state) =>
                                        ProfileViewScreen(),
                                  ),
                                  GoRoute(
                                    path: "notification",
                                    name: AppRoutes.notification,
                                    builder: (context, state) =>
                                        const NotificationScreen(),
                                  ),
                                  GoRoute(
                                    path: "subscription",
                                    name: AppRoutes.subscription,
                                    builder: (context, state) =>
                                        SubscriptionScreen(),
                                  ),
                                  GoRoute(
                                    path: "tournament",
                                    name: AppRoutes.tournament,
                                    builder: (context, state) =>
                                        TournamentPage(),
                                  ),
                                  GoRoute(
                                    path: "donation",
                                    name: AppRoutes.donation,
                                    builder: (context, state) => DonationPage(),
                                  ),
                                  GoRoute(
                                    path: "quizzes_cubit",
                                    name: AppRoutes.quizzes,
                                    builder: (context, state) => QuizzesPage(),
                                  ),
                                  GoRoute(
                                    path: "quiz_detail",
                                    name: AppRoutes.quizDetail,
                                    builder: (context, state) {
                                      final extra = state.extra as Map<String,
                                          dynamic>; // Map sifatida parse qilamiz
                                      final quizId = extra["quizId"] as int;
                                      final packName =
                                          extra["packName"] as String;
                                      return QuizDetailPage(
                                        quizPackId: quizId,
                                        packName: packName,
                                      );
                                    },
                                  ),
                                  GoRoute(
                                    path: "history",
                                    name: AppRoutes.history,
                                    builder: (context, state) =>
                                        HistoryScreen(),
                                  ),
                                  GoRoute(
                                    path: "about",
                                    name: AppRoutes.about,
                                    builder: (context, state) => AboutApp(),
                                  ),
                                ]),
                          ]),
                      GoRoute(
                        path: "location",
                        name: AppRoutes.locationScreen,
                        builder: (context, state) => LocationsScreen(),
                      ),
                      GoRoute(
                        path: "logIn",
                        name: AppRoutes.login,
                        builder: (context, state) => const LogInScreen(),
                      ),
                      GoRoute(
                        path: "smsVerify",
                        name: AppRoutes.sms,
                        builder: (context, state) => const SmsVerification(),
                      ),
                    ]),
                GoRoute(
                  path: "owner",
                  name: AppRoutes.ownerDashboard,
                  builder: (context, state) => const OwnerDashboard(),
                ),
                GoRoute(
                  path: "subStadium",
                  name: AppRoutes.subStadium,
                  builder: (context, state) {
                    final substadium = state.extra as Substadiums;
                    return SubstadiumScreen(substadium: substadium);
                  },
                ),
                GoRoute(
                  path: "locationPicker",
                  name: AppRoutes.locationPicker,
                  builder: (context, state) => LocationPickerScreen(),
                ),
                GoRoute(
                  path: "addStadium",
                  name: AppRoutes.addStadium,
                  builder: (context, state) => AddStadiumScreen(),
                ),
                GoRoute(
                  path: "ownerSubs",
                  name: AppRoutes.ownerSubs,
                  builder: (context, state) => OwnerSubscriptionPage(),
                ),
              ]),
        ]),
  ],
);
