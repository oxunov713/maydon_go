import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maydon_go/src/provider/booking_provider.dart';

import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/provider/all_stadium_provider.dart';
import 'src/provider/auth_provider.dart';
import 'src/provider/home_provider.dart';
import 'src/provider/locale_provider.dart';
import 'src/provider/saved_stadium_provider.dart';
import 'src/provider/top_rating_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => StadiumProvider()),
          ChangeNotifierProvider(create: (_) => TopRatingProvider()),
          ChangeNotifierProvider(create: (_) => SavedStadiumsProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => BookingDateProvider()),
        ],
        child: const App(),
      ),
    );
  });
}
