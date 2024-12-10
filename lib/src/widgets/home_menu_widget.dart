import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../style/app_colors.dart';

Widget buildIconButton({
  required String iconPath,
  required bool isLeftAligned,
}) {
  return Container(
    height: 60,
    width: 90,
    margin: const EdgeInsets.only(top: 15),
    decoration: BoxDecoration(
      color: AppColors.green,
      borderRadius: isLeftAligned
          ? const BorderRadius.only(
        bottomLeft: Radius.circular(20),
        topLeft: Radius.circular(20),
      )
          : const BorderRadius.only(
        bottomRight: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: SvgPicture.asset(
        iconPath,
        height: 25,
        width: 25,
      ),
    ),
  );
}
