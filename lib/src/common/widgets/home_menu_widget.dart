import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydon_go/src/user/bloc/all_stadium_cubit/all_stadium_cubit.dart';
import 'package:provider/provider.dart';

import '../../user/ui/home/all_stadiums_screen.dart';
import '../style/app_colors.dart';

Widget buildIconButton({
  required String iconPath,
  required bool isLeftAligned,
  required GlobalKey<ScaffoldState> scaffoldKey,
  required BuildContext context,
  required FocusNode focusNode,
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
    child: InkWell(
      onTap: () {
        if (!isLeftAligned) {
          // Open the drawer on the left side
          scaffoldKey.currentState?.openDrawer();
        } else {
          context.read<StadiumCubit>().toggleSearchMode();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllStadiumsScreen(),
              ));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SvgPicture.asset(
          iconPath,
          height: 25,
          width: 25,
        ),
      ),
    ),
  );
}
