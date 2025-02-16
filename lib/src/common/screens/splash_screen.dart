import 'dart:io'; // For platform-specific checks
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      final status = await Permission.location.request();

      if (status.isGranted) {
        // Permission granted, navigate based on token
        _navigateBasedOnToken();
        break;
      } else if (status.isDenied) {
        // Show retry dialog
        await _showPermissionDialog();
        retryCount++;
      } else if (status.isPermanentlyDenied) {
        // Open app settings for permanently denied permission
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
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateBasedOnToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

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
      // Handle SharedPreferences initialization error
      debugPrint("Error accessing SharedPreferences: $e");
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
                const Text(
                  "Maydon Go",
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
