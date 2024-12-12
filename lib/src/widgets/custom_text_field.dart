import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/app_colors.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  Function()? toggleVisibility, // Add function to toggle visibility
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
      suffixIcon: toggleVisibility != null
          ? IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.main,
        ),
        onPressed: toggleVisibility,
      )
          : null, // Display the icon button if toggleVisibility is provided
    ),
    obscureText: obscureText,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: validator,
  );
}
