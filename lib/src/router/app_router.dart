import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/model/stadium_model.dart';
import 'package:maydon_go/src/screens/home/all_stadiums_screen.dart';
import 'package:maydon_go/src/screens/home/locations_screen.dart';
import 'package:maydon_go/src/screens/home/stadium_detail.dart';
import 'package:maydon_go/src/widgets/sms_verification.dart';

import '../screens/auth/choose_language_screens.dart';
import '../screens/auth/log_in_screen.dart';
import '../screens/auth/owner_sign_up.dart';
import '../screens/auth/role_screen.dart';
import '../screens/auth/user_sign_up_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/splash_screen.dart';
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
                  path: "signUp",
                  name: AppRoutes.signUp,
                  builder: (context, state) => const SignUpScreen(),
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
                  path: "detail",
                  name: AppRoutes.detailStadium,
                  builder: (context, state) {
                    final stadium = state.extra as Stadium;
                    return StadiumDetailScreen(stadium: stadium);
                  },
                ),
              ]),
          GoRoute(
            path: "location",
            name: AppRoutes.locationScreen,
            builder: (context, state) => const LocationsScreen(),
          )
        ]),
  ],
);
