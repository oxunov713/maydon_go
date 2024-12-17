import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class OwnerSignUp extends StatelessWidget {
  const OwnerSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ro'yxatdan o'tish"),
        backgroundColor: AppColors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Iltimos, avval saytdan ro'yxatdan o'ting"),
            TextButton(
              onPressed: () {},
              child: Text(
                "Link",
                style: TextStyle(
                    color: AppColors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
