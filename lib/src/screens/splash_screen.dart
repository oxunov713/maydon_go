import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:maydon_go/src/screens/role_screen.dart';
import 'package:maydon_go/src/style/app_colors.dart';
import 'package:maydon_go/src/style/app_icons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration(milliseconds: 3500),
      () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoleScreen(),
        ),
      ),
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
            child: Image(
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
                Text(
                  "Maydon Go",
                  style: TextStyle(
                      color: AppColors.main,
                      fontWeight: FontWeight.w700,
                      fontSize: 40),
                ),
                Text(
                  "Futbol maydonlarini qidirish ilovasi",
                  style: TextStyle(color: AppColors.secondary, fontSize: 14),
                ),
                Lottie.asset(AppIcons.downloadLottie,
                    fit: BoxFit.fill, height: 90),
                SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
