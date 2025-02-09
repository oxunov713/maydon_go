import 'package:flutter/material.dart';
import '../style/app_colors.dart';

class BottomSignButton extends StatelessWidget {
  const BottomSignButton({
    super.key,
    required this.function,
    required this.text,
    required this.isdisabledBT,
    this.isLoading = false, // ✅ Yangi parametr qo‘shildi
  });

  final VoidCallback function;
  final String text;
  final bool isdisabledBT;
  final bool isLoading; // ✅ Yuklanish uchun flag

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: isdisabledBT && !isLoading ? function : null, // ✅ Yuklanayotganda bosilmaydi
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          disabledBackgroundColor: AppColors.green40,
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        ) // ✅ Yuklanayotganda indikator chiqadi
            : Text(
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
