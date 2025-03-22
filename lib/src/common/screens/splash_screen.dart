import 'dart:io'; // For platform-specific checks
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:maydon_go/src/common/service/shared_preference_service.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:permission_handler/permission_handler.dart';

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
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount < maxRetries) {
      final status = await Permission.location.request();
      final status2 = await Permission.notification.request();

      if (status.isGranted && status2.isGranted) {
        _navigateBasedOnToken();
        break;
      } else if (status.isDenied && status2.isDenied) {
        await _showPermissionDialog();
        retryCount++;
      } else if (status.isPermanentlyDenied && status2.isPermanentlyDenied) {
        await openAppSettings();
        break;
      }
    }
  }

  Future<void> _showPermissionDialog() async {
    const title = "Location Permission Required";
    final content = Platform.isIOS
        ? "Please enable location services in your device settings to use this app and find nearby stadiums."
        : "Please grant location access to use this app and find nearby stadiums. You can enable it in your device settings.";

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Close dialog
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateBasedOnToken() async {
    try {
      final String? token = await ShPService.getToken();

      Future.delayed(
        const Duration(seconds: 3),
        () {
          if (token != null && token.isNotEmpty) {
            context.goNamed(AppRoutes.home);
          } else {
            context.goNamed(AppRoutes.chooseLanguage);
          }
        },
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: const Image(
              image: AssetImage(AppIcons.splashScreen),
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.lan.appName,
                  style: TextStyle(
                    color: AppColors.main,
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                  ),
                ),
                const Text(
                  "Futbol maydonlarini qidirish ilovasi",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Lottie.asset(
                  AppIcons.downloadLottie,
                  fit: BoxFit.fill,
                  height: 90,
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
