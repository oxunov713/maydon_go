import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/screens/owner_subscription.dart';
import 'package:maydon_go/src/common/model/userinfo_model.dart';
import 'package:maydon_go/src/common/screens/splash_screen.dart';
import 'package:maydon_go/src/owner/screens/home/location_picker_screen.dart';
import 'package:maydon_go/src/owner/screens/home/owner_dashboard.dart';
import 'package:maydon_go/src/owner/screens/home/owner_detail_screen.dart';
import 'package:maydon_go/src/owner/screens/home/owner_stadium_detail.dart';
import 'package:maydon_go/src/user/ui/home/about_app.dart';
import 'package:maydon_go/src/user/ui/home/chat_screen.dart';
import 'package:maydon_go/src/user/ui/home/club_detail_screen.dart';
import 'package:maydon_go/src/user/ui/home/club_teammates.dart';
import 'package:maydon_go/src/user/ui/home/history_screen.dart';
import 'package:maydon_go/src/user/ui/home/my_club_screen.dart';
import 'package:maydon_go/src/user/ui/home/notification_screen.dart';
import 'package:maydon_go/src/user/ui/home/profile_screen.dart';
import 'package:maydon_go/src/user/ui/home/profile_view_screen.dart';
import 'package:maydon_go/src/user/ui/home/quizzes_screen.dart';
import 'package:maydon_go/src/user/ui/home/settings_screen.dart';
import 'package:maydon_go/src/user/ui/home/subscription_screen.dart';
import 'package:maydon_go/src/user/ui/home/user_coins_ranking.dart';

import '../../owner/screens/home/add_stadium_screen.dart';
import '../../user/ui/home/all_stadiums_screen.dart';
import '../../user/ui/home/home_screen.dart';
import '../../user/ui/home/locations_screen.dart';

import '../../user/ui/home/saved_stadiums.dart';
import '../../user/ui/home/stadium_detail.dart';
import '../auth/log_in_screen.dart';
import '../auth/sign_up_screen.dart';
import '../model/stadium_model.dart';
import '../screens/choose_language_screens.dart';
import '../screens/role_screen.dart';
import '../screens/welcome_screen.dart';
import '../../user/ui/home/sms_verification.dart';
import 'app_routes.dart';

class AppRouter {
  static get goRouter => _router;
}

final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => SplashScreen(), routes: [
      GoRoute(
        path: "lan",
        name: AppRoutes.chooseLanguage,
        builder: (context, state) => const ChooseLanguageScreens(),
      ),
      GoRoute(
        path: "welcome",
        name: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
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
                            return StadiumDetailScreen(stadiumId: stadiumId);
                          },
                        ),
                        GoRoute(
                          path: "saved",
                          name: AppRoutes.saved,
                          builder: (context, state) => const SavedStadiums(),
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
                          path: "chat",
                          name: AppRoutes.chat,
                          builder: (context, state) {
                            final user = state.extra as UserInfo;
                            return ChatScreen(user: user);
                          },
                        ),
                        GoRoute(
                          path: "clubDetail",
                          name: AppRoutes.clubDetail,
                          builder: (context, state) => const ClubDetailScreen(),
                        ),
                        GoRoute(
                          path: "clubTeammates",
                          name: AppRoutes.clubTeammates,
                          builder: (context, state) => const ClubTeammates(),
                        ),
                        GoRoute(
                            path: "profile",
                            name: AppRoutes.profile,
                            builder: (context, state) => const ProfileScreen(),
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
                                path: "quizzes_cubit",
                                name: AppRoutes.quizzes,
                                builder: (context, state) => QuizzesScreen(),
                              ),
                              GoRoute(
                                path: "settings",
                                name: AppRoutes.settings,
                                builder: (context, state) =>
                                    const SettingsScreen(),
                              ),
                              GoRoute(
                                path: "history",
                                name: AppRoutes.history,
                                builder: (context, state) => HistoryScreen(),
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
                    builder: (context, state) => const LocationsScreen(),
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
              path: "ownerStadiumDetail",
              name: AppRoutes.ownerDetail,
              builder: (context, state) => OwnerDetailScreen(),
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
            GoRoute(
              path: "ownerProfileDetail",
              name: AppRoutes.ownerProfileDetail,
              builder: (context, state) => OwnerDetailScreen(),
            ),
          ]),
    ]),
  ],
);
