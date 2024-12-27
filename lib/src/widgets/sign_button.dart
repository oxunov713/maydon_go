import 'package:flutter/material.dart';

import '../style/app_colors.dart';

class BottomSignButton extends StatelessWidget {
  BottomSignButton(
      {super.key,
      required this.function,
      required this.text,
      required this.isdisabledBT});

  final VoidCallback function;
  final String text;
  final bool isdisabledBT;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: isdisabledBT ? function : null,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            disabledBackgroundColor: AppColors.green40),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
