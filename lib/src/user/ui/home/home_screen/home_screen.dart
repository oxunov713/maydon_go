import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/style/app_icons.dart';
import '../../../bloc/home_cubit/home_cubit.dart';
import '../../../bloc/home_cubit/home_state.dart';
import '../stadiums_screen/all_stadiums_screen.dart';
import '../stadiums_screen/locations_screen.dart';
import 'my_club_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../stadiums_screen/saved_stadiums.dart';

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

    // Hajmni kichraytirish uchun yangi o‘lchamlar
    double floatingButtonOuterRadius = screenWidth * 0.09; // Kichraytirildi
    double floatingButtonInnerRadius = screenWidth * 0.08; // Kichraytirildi
    double floatingButtonIconSize = screenWidth * 0.08; // Kichraytirildi

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
                      children: [
                        const MyClubScreen(key: PageStorageKey('myClubScreen')),
                        const AllStadiumsScreen(),
                        const LocationsScreen(
                            key: PageStorageKey('locationsScreen')),
                        const SavedStadiums(
                            key: PageStorageKey('savedStadiums')),
                        const ProfileScreen(
                            key: PageStorageKey('profileScreen')),
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              // Pastga siljitish uchun padding
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
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(),
          bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return Theme(
                data: Theme.of(context).copyWith(
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: AppColors.green,
                    unselectedItemColor: AppColors.white,
                    selectedItemColor: AppColors.white,
                    selectedIconTheme:
                        IconThemeData(size: floatingButtonIconSize * 0.75),
                    unselectedIconTheme:
                        IconThemeData(size: floatingButtonIconSize * 0.75),
                    selectedLabelStyle: const TextStyle(fontSize: 0),
                    unselectedLabelStyle: const TextStyle(fontSize: 0),
                  ),
                ),
                child: SizedBox(
                  height: 55, // <-- bu yerda balandligini pasaytiryapmiz
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    iconSize: floatingButtonIconSize * 0.75,
                    // kichikroq ikon
                    currentIndex: context.read<HomeCubit>().selectedIndex,
                    onTap: (value) => (value == 2)
                        ? null
                        : context.read<HomeCubit>().updateIndex(value),
                    items: [
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          AppIcons.homeIcon,
                          color: AppColors.white,
                          height: floatingButtonIconSize * 0.75,
                        ),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          AppIcons.stadionsIcon,
                          color: AppColors.white,
                          height: floatingButtonIconSize * 0.75,
                        ),
                        label: "",
                      ),
                      const BottomNavigationBarItem(
                        icon: SizedBox.shrink(),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bookmark_border,
                            size: floatingButtonIconSize * 0.8,color: AppColors.white,),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          AppIcons.profileIcon,
                          color: AppColors.white,
                          height: floatingButtonIconSize * 0.8,
                        ),
                        label: "",
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2;
    final double fabY = scaffoldGeometry.contentBottom -
        scaffoldGeometry.floatingActionButtonSize.height -
        -60;
    return Offset(fabX, fabY);
  }
}
