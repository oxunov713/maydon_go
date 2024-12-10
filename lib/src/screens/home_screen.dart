import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maydon_go/src/style/app_colors.dart';
import 'package:maydon_go/src/style/app_icons.dart';

import '../widgets/home_menu_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildIconButton(
                    iconPath: AppIcons.menuIcon, isLeftAligned: false),
                buildIconButton(
                    iconPath: AppIcons.searchIcon, isLeftAligned: true),
              ],
            ),
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 34),
          child: CircleAvatar(
            radius: 46,
            backgroundColor: AppColors.white,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.green,
              child: SvgPicture.asset(
                AppIcons.locationIcon,
                height: 45,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
