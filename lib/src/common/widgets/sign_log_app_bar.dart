import 'package:flutter/material.dart';

import '../style/app_colors.dart';

Widget signLogAppBar(BuildContext context, String title) {
  return Column(spacing: 20, children: [
    SizedBox.square(
      dimension: MediaQuery.sizeOf(context).height / 5,
      child: Image.asset("assets/images/shoot.png"),
    ),
    Text(
      textAlign: TextAlign.center,
      title,
      style: TextStyle(
          color: AppColors.green, fontSize: 25, fontWeight: FontWeight.bold),
    ),
  ]);
}
