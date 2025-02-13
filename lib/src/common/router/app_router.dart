import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/screens/welcome_screen.dart';

import '../../user/ui/auth/user_log_in_screen.dart';
import '../../owner/screens/auth/owner_sign_up.dart';
import '../../user/ui/auth/user_sign_up_screen.dart';
import '../../user/ui/home/all_stadiums_screen.dart';
import '../../user/ui/home/home_screen.dart';
import '../../user/ui/home/locations_screen.dart';
import '../../user/ui/home/payment_page.dart';

import '../../user/ui/home/stadium_detail.dart';
import '../model/stadium_model.dart';
import '../screens/choose_language_screens.dart';
import '../screens/role_screen.dart';
import '../screens/splash_screen.dart';
import '../widgets/sms_verification.dart';
import 'app_routes.dart';

class AppRouter {
  static get goRouter => _router;
}

final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
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
                  path: "ownerSignUp",
                  name: AppRoutes.ownerSignUp,
                  builder: (context, state) => const OwnerSignUp(),
                ),
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
                              builder: (context, state) => AllStadiumsScreen(),
                            ),
                            GoRoute(
                              path: "payment",
                              name: AppRoutes.paymentPage,
                              builder: (context, state) => PaymentPage(),
                            ),
                            GoRoute(
                              path: "detail",
                              name: AppRoutes.detailStadium,
                              builder: (context, state) {
                                final stadium = state.extra as StadiumDetail;
                                return StadiumDetailScreen(stadium: stadium);
                              },
                            ),
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
              ]),
        ]),
  ],
);
