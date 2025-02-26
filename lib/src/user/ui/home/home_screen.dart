import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../bloc/home_cubit/home_cubit.dart';
import '../../bloc/home_cubit/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final homeCubit = context.read<HomeCubit>();

    if (!_isInitialized) {
      _isInitialized = true;
      homeCubit.initializeApp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double floatingButtonOuterRadius = screenWidth * 0.115;
    double floatingButtonInnerRadius = screenWidth * 0.1;
    double floatingButtonIconSize = screenWidth * 0.1;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // ✅ Klaviatura UI-ni ko'tarmasligi uchun
        key: _scaffoldKey,
        body: Column(
          children: [
            Expanded(
              // ✅ Oq bo'sh joyni yo'q qiladi
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return context.read<HomeCubit>().currentPage();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.read<HomeCubit>().updateIndex(2),
          onDoubleTap: () => context.read<HomeCubit>().goToCurrentLocation(),
          child: CircleAvatar(
            radius: floatingButtonOuterRadius,
            backgroundColor: AppColors.white,
            child: CircleAvatar(
              radius: floatingButtonInnerRadius,
              backgroundColor: AppColors.green,
              child: SvgPicture.asset(
                AppIcons.locationIcon,
                height: floatingButtonIconSize,
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: floatingButtonIconSize,
              currentIndex: context.read<HomeCubit>().selectedIndex,
              onTap: (value) => (value == 2)
                  ? null
                  : context.read<HomeCubit>().updateIndex(value),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 8, top: 5),
                    child: SvgPicture.asset(
                      AppIcons.stadionsIcon,
                      color: AppColors.white,
                      height: floatingButtonIconSize * 0.7,
                    ),
                  ),
                  label: context.lan.stadiums,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_border),
                  label: context.lan.saved,
                ),
                const BottomNavigationBarItem(
                  icon: SizedBox.shrink(),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: SvgPicture.asset(
                      AppIcons.ballIcon,
                      color: AppColors.white,
                      height: floatingButtonIconSize * 0.9,
                    ),
                  ),
                  label: context.lan.myClub,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: SvgPicture.asset(
                      AppIcons.profileIcon,
                      color: AppColors.white,
                      height: floatingButtonIconSize * 0.8,
                    ),
                  ),
                  label: context.lan.profile,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
