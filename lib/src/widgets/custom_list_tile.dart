import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget customListTile({
  required String text,
  required String icon,
  required Widget? goToScreen,
  required BuildContext context,
}) {
  return ListTile(
    leading: SvgPicture.asset(icon),
    title: Text(
      text,
    ),
    onTap: () => (goToScreen == null)
        ? null
        : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => goToScreen!,
            ),
          ),
  );
}
