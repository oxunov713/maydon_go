import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../router/app_routes.dart';
import '../style/app_colors.dart';
import '../style/app_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 3500),
      () => context.goNamed(AppRoutes.chooseLanguage),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: deviceHeight,
            width: deviceWidth,
            child: const Image(
              fit: BoxFit.cover,
              image: AssetImage(
                AppIcons.splashScreen,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Maydon Go",
                  style: TextStyle(
                      color: AppColors.main,
                      fontWeight: FontWeight.w700,
                      fontSize: 40),
                ),
                const Text(
                  "Futbol maydonlarini qidirish ilovasi",
                  style: TextStyle(color: AppColors.secondary, fontSize: 14),
                ),
                Lottie.asset(AppIcons.downloadLottie,
                    fit: BoxFit.fill, height: 90),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
