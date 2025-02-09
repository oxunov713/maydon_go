import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../style/app_colors.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  bool obscureText = false,
  bool isNumber = false,
  bool isName = false,
  bool isPassword = false,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  Function()? toggleVisibility,
  Function(String)? onChanged, // onChanged callback
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.main),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: AppColors.main, width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: AppColors.green, width: 2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(color: AppColors.red, width: 2),
      ),
      prefixIcon: isNumber
          ? const Icon(Icons.phone, color: AppColors.main)
          : isName
              ? const Icon(Icons.person,
                  color: AppColors.main) // 🔥 Ism uchun ikonka
              : isPassword
                  ? const Icon(Icons.lock, color: AppColors.main)
                  : null,
      prefixText: isNumber ? "+998 " : null,
      prefixStyle: const TextStyle(
        color: AppColors.main,
        fontWeight: FontWeight.bold,
      ),
      suffixIcon: toggleVisibility != null
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.main,
              ),
              onPressed: toggleVisibility,
            )
          : null,
    ),
    obscureText: obscureText,
    keyboardType: isNumber ? TextInputType.phone : keyboardType,
    inputFormatters: inputFormatters,
    validator: validator,
    onChanged: onChanged,
  );
}
