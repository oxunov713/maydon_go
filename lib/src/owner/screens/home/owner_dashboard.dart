import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maydon_go/generated/l10n.dart'; // Import generated localizations
import 'package:maydon_go/src/owner/bloc/home/owner_home_cubit.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_state.dart';
import 'package:maydon_go/src/owner/screens/home/add_slot_screen.dart';
import 'package:maydon_go/src/owner/screens/home/bron_list_screen.dart';
import 'package:maydon_go/src/owner/screens/home/owner_profile_screen.dart';
import '../../../common/l10n/app_localizations.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  @override
  Widget build(BuildContextContext) {
    final l10n = AppLocalizations.of(context); // Access translations
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
              child: BlocBuilder<OwnerHomeCubit, OwnerHomeState>(
                buildWhen: (previous, current) {
                  return previous.selectedIndex != current.selectedIndex;
                },
                builder: (context, state) {
                  return IndexedStack(
                    index: state.selectedIndex,
                    children: [
                      const BronListScreen(),
                      const AddSlotScreen(),
                      OwnerProfileScreen(),
                    ],
                  );
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
              child: SvgPicture.asset(
                AppIcons.stadionsIcon,
                color: AppColors.white,
                height: 30,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: BlocBuilder<OwnerHomeCubit, OwnerHomeState>(
          buildWhen: (previous, current) {
            return previous.selectedIndex != current.selectedIndex;
          },
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: floatingButtonIconSize,
              currentIndex: state.selectedIndex,
              onTap: (value) =>
                  context.read<OwnerHomeCubit>().updateIndex(value),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.menu),
                  label: l10n?.bookingsLabel,
                ),
                const BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppIcons.profileIcon,
                    color: AppColors.white,
                    height: 24,
                  ),
                  label: l10n?.profileLabel,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}