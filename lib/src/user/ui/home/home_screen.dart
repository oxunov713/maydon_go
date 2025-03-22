import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';

import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';
import '../../bloc/home_cubit/home_cubit.dart';
import '../../bloc/home_cubit/home_state.dart';
import 'all_stadiums_screen.dart';
import 'locations_screen.dart';
import 'my_club_screen.dart';
import 'profile_screen.dart';
import 'saved_stadiums.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final homeCubit = context.read<HomeCubit>();

    if (!_isInitialized) {
      _isInitialized = true;
      homeCubit.initializeApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double floatingButtonOuterRadius = screenWidth * 0.115;
    double floatingButtonInnerRadius = screenWidth * 0.1;
    double floatingButtonIconSize = screenWidth * 0.1;
    super.build(context);
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, state) {
                    return IndexedStack(

                      index: context.read<HomeCubit>().selectedIndex,
                      children:  [
                        AllStadiumsScreen(),
                        SavedStadiums(key: PageStorageKey('savedStadiums')),
                        LocationsScreen(key: PageStorageKey('locationsScreen')),
                        MyClubScreen(key: PageStorageKey('myClubScreen')),
                        ProfileScreen(key: PageStorageKey('profileScreen')),
                      ],
                    );
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
            buildWhen: (previous, current) => previous != current,
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
      ),
    );
  }
}
