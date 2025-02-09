import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import '../style/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/grass.jfif",
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: HalfMoonPainter(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const Spacer(flex: 1), // Bo'sh joy qo'shish
                    const Column(
                      children: [
                        Text(
                          "Maydon Go",
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          "Futbol maydonlarini qidirish ilovasi",
                          style: TextStyle(
                            color: AppColors.white2,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 2), // Bo'sh joy qo'shish
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              foregroundColor: AppColors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () => context.pushNamed(AppRoutes.login),
                            child: Text(
                              context.lan.login,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.green,
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            onPressed: () =>
                                context.pushNamed(AppRoutes.signUp),
                            child: Text(
                              context.lan.signUp,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50), // Pastki bo'sh joy
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HalfMoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.green;

    Path path = Path();
    double centerX = size.width / 2.2;
    double centerY = size.height / 3;

    path.moveTo(0, centerY);
    path.quadraticBezierTo(centerX, size.height * 0.49, size.width, centerY);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
