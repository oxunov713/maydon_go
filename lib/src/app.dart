import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'provider/locale_provider.dart';
import 'router/app_router.dart';
import 'style/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.goRouter,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('en'),
        Locale('uz'),
        Locale('ru'),
      ],
      locale: Provider.of<LocaleProvider>(context).locale,
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
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.green,
          unselectedItemColor: AppColors.white,
          selectedItemColor: AppColors.blue,
          selectedIconTheme: IconThemeData(
            color: AppColors.blue
          ),
          selectedLabelStyle: TextStyle(color: AppColors.green40, fontSize: 12),
          unselectedLabelStyle: TextStyle(color: AppColors.grey4, fontSize: 12),
        ),
      ),
    );
  }
}
