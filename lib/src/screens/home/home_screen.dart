import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../../provider/home_provider.dart';
import '../../style/app_colors.dart';
import '../../style/app_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    // Initialize location and markers only once
    if (homeProvider.currentLocation == null) {
      homeProvider.initializeLocation(context);
      homeProvider.fetchStadiums().then((_) {
        homeProvider.setMarkers();
      });
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
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: Provider.of<HomeProvider>(
          context,
        ).currentPage(),
        floatingActionButton: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () =>
              Provider.of<HomeProvider>(context, listen: false).updateIndex(2),
          onDoubleTap: () => Provider.of<HomeProvider>(context, listen: false)
              .goToCurrentLocation(),
          child: CircleAvatar(
            radius: floatingButtonOuterRadius,
            backgroundColor: AppColors.white,
            child: CircleAvatar(
              radius: floatingButtonInnerRadius,
              backgroundColor: AppColors.green,
              child: SvgPicture.asset(
                AppIcons.locationIcon, // Replace with your custom SVG icon
                height: floatingButtonIconSize,
                color: AppColors.white, // Customize icon color if needed
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: floatingButtonIconSize,
          currentIndex:
              Provider.of<HomeProvider>(context, listen: true).selectedIndex,
          onTap: (value) => (value == 2)
              ? null
              : Provider.of<HomeProvider>(context, listen: false)
                  .updateIndex(value),
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
              label: "Stadionlar",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: "Saqlangan",
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Tarix",
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
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
// drawer: Drawer(
//   child: ListView(
//     children: <Widget>[
//       InkWell(
//         onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProfileScreen(),
//             )),
//         child: const UserAccountsDrawerHeader(
//           currentAccountPicture: CircleAvatar(
//             backgroundImage: AssetImage(AppIcons.avatarImage),
//           ),
//           accountEmail: Text("+998900050713"),
//           accountName: Text(
//             "Azizbek Oxunov",
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//           decoration: BoxDecoration(
//             color: AppColors.green,
//           ),
//         ),
//       ),
//       customListTile(
//         context: context,
//         text: "Barcha maydonlar",
//         icon: AppIcons.stadionsIcon,
//         goToScreen: AllStadiumsScreen(),
//       ),
//       customListTile(
//         context: context,
//         text: "Top Reyting",
//         icon: AppIcons.topRatingsIcon,
//         goToScreen: TopRatings(),
//       ),
//       ListTile(
//         leading: Icon(
//           Icons.bookmark_border_outlined,
//           color: AppColors.main,
//         ),
//         title: Text(
//           "Saqlanganlar",
//         ),
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SavedStadiumsScreen(),
//           ),
//         ),
//       ),
//       customListTile(
//           context: context,
//           text: "Profil",
//           icon: AppIcons.profileIcon,
//           goToScreen: ProfileScreen()),
//       customListTile(
//         context: context,
//         text: "Tarix",
//         icon: AppIcons.historyIcon,
//         goToScreen: HistoryScreen(),
//       ),
//       // customListTile(
//       //   context: context,
//       //   text: "Sozlamalar",
//       //   icon: AppIcons.settingsIcon,
//       //   goToScreen: SettingsScreen(),
//       // ),
//       customListTile(
//         context: context,
//         text: "Yordam",
//         icon: AppIcons.faqIcon,
//         goToScreen: null,
//       ),
//       customListTile(
//         context: context,
//         text: "Xabarlar",
//         icon: AppIcons.chatIcon,
//         goToScreen: null,
//       ),
//     ],
//   ),
// ),
