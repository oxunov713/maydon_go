// lib/src/common/screens/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../user/bloc/locale_cubit/locale_cubit.dart';
import '../l10n/app_localizations.dart';
import '../router/app_router.dart';
import '../style/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          final router = AppRouter.goRouter;

          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            supportedLocales: const [
              Locale('en'),
              Locale('uz'),
              Locale('ru'),
            ],
            locale: locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            theme: ThemeData(
              fontFamily: "Gilroy",
              scaffoldBackgroundColor: AppColors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.green,
                foregroundColor: AppColors.white,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  fontFamily: "Gilroy",
                ),
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: AppColors.green,
                unselectedItemColor: AppColors.white,
                selectedItemColor: AppColors.white,
                selectedIconTheme: IconThemeData(color: AppColors.white),
                selectedLabelStyle:
                    TextStyle(color: AppColors.green40, fontSize: 12),
                unselectedLabelStyle:
                    TextStyle(color: AppColors.grey4, fontSize: 12),
              ),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: AppColors.green,
                selectionColor: AppColors.green40,
                selectionHandleColor: AppColors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
