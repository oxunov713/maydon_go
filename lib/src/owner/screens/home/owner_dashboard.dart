import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_cubit.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_state.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double floatingButtonOuterRadius = screenWidth * 0.115;
    double floatingButtonInnerRadius = screenWidth * 0.1;
    double floatingButtonIconSize = screenWidth * 0.1;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              // ✅ Oq bo'sh joyni yo'q qiladi
              child: BlocBuilder<OwnerHomeCubit, OwnerHomeState>(
                builder: (context, state) {
                  return context.read<OwnerHomeCubit>().currentPage();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.read<OwnerHomeCubit>().updateIndex(1),
          child: CircleAvatar(
            radius: floatingButtonOuterRadius,
            backgroundColor: AppColors.white,
            child: CircleAvatar(
                radius: floatingButtonInnerRadius,
                backgroundColor: AppColors.green,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                )),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: BlocBuilder<OwnerHomeCubit, OwnerHomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: floatingButtonIconSize,
              currentIndex: context.read<OwnerHomeCubit>().selectedIndex,
              onTap: (value) => (value == 1)
                  ? null
                  : context.read<OwnerHomeCubit>().updateIndex(value),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Stadionlar",
                ),
                const BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppIcons.profileIcon,
                    color: AppColors.white,
                    height: floatingButtonIconSize * 0.8,
                  ),
                  label: "Profile",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
