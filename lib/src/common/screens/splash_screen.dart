import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:maydon_go/src/common/service/shared_preference_service.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../user/bloc/auth_cubit/auth_cubit.dart';
import '../../user/bloc/auth_cubit/auth_state.dart';
import '../router/app_routes.dart';
import '../style/app_colors.dart';
import '../style/app_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Logger _logger = Logger();
  bool _isNavigationInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNavigation();
    });
  }

  Future<void> _initNavigation() async {
    await _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    try {
      int retryCount = 0;
      const maxRetries = 2;

      while (retryCount < maxRetries && !_isNavigationInProgress) {
        final status = await Permission.location.request();
        final status2 = await Permission.notification.request();

        if (status.isGranted && status2.isGranted) {
          await _navigateBasedOnAuthState();
          break;
        } else if (status.isDenied && status2.isDenied) {
          await _showPermissionDialog();
          retryCount++;
        } else if (status.isPermanentlyDenied || status2.isPermanentlyDenied) {
          await openAppSettings();
          break;
        }
      }
    } catch (e) {
      _logger.e('Permission error: $e');
      _safeNavigateTo(AppRoutes.chooseLanguage);
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
              Navigator.pop(context);
              _requestLocationPermission();
            },
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateBasedOnAuthState() async {
    if (_isNavigationInProgress) return;
    _isNavigationInProgress = true;

    try {
      // Add timeout to prevent infinite waiting
      await Future.any([
        _performNavigation(),
        Future.delayed(const Duration(seconds: 5), () {
          throw TimeoutException('Navigation timed out');
        }),
      ]);
    } on TimeoutException catch (e) {
      _logger.e('Navigation timeout: $e');
      _safeNavigateTo(AppRoutes.chooseLanguage);
    } catch (e) {
      _logger.e('Navigation error: $e');
      _safeNavigateTo(AppRoutes.chooseLanguage);
    } finally {
      _isNavigationInProgress = false;
    }
  }

  Future<void> _performNavigation() async {
    final String? token = await ShPService.getToken();
    final String? roleString = await ShPService.getRole();

    if (!mounted) return;

    // Debug logs
    _logger.d('Token: $token');
    _logger.d('Role: $roleString');

    if (token == null || token.isEmpty) {
      _safeNavigateTo(AppRoutes.chooseLanguage);
      return;
    }

    // Convert role string to enum
    try {
      final role = UserRole.values.firstWhere(
            (e) => e.toString() == roleString,
        orElse: () => UserRole.none,
      );

      _navigateBasedOnRole(role);
    } catch (e) {
      _logger.e('Role conversion error: $e');
      _safeNavigateTo(AppRoutes.chooseLanguage);
    }
  }

  void _navigateBasedOnRole(UserRole role) {
    if (!mounted) return;

    switch (role) {
      case UserRole.user:
        _safeNavigateTo(AppRoutes.home);
        break;
      case UserRole.owner:
        _safeNavigateTo(AppRoutes.ownerDashboard);
        break;
      case UserRole.none:
        _safeNavigateTo(AppRoutes.chooseLanguage);
        break;
    }
  }

  void _safeNavigateTo(String routeName) {
    if (!mounted) return;
    context.goNamed(routeName);
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