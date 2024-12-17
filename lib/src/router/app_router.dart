import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/router/app_routes.dart';
import 'package:maydon_go/src/screens/auth/choose_language_screens.dart';
import 'package:maydon_go/src/screens/auth/owner_sign_up.dart';
import 'package:maydon_go/src/screens/auth/role_screen.dart';
import 'package:maydon_go/src/screens/auth/log_in_screen.dart';
import 'package:maydon_go/src/screens/auth/user_sign_up_screen.dart';
import 'package:maydon_go/src/screens/home/home_screen.dart';

import '../screens/splash_screen.dart';

class AppRouter {
  static get goRouter => _router;
}

final GoRouter _router = GoRouter(
  initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
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
              ]),
          GoRoute(
            path: "home",
            name: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          )
        ]),
  ],
);
