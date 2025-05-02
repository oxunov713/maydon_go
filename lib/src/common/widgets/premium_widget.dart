import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';
import '../style/app_colors.dart';

void showBuyPremiumBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 40, color: AppColors.blue),
            const SizedBox(height: 16),
            const Text(
              'Upgrade to Go +',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.main),
            ),
            const SizedBox(height: 8),
            const Text(
              'To add more connections, please upgrade your subscription.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
              ),
              onPressed: () {
                context.pop();

                context.pushNamed(AppRoutes.subscription);
              },
              child: const Text('Buy Premium',style: TextStyle(color: AppColors.white),),
            ),
          ],
        ),
      );
    },
  );
}