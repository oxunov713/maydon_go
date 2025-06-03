import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/service/url_launcher_service.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/user/bloc/booking_history/booking_history_cubit.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/user/bloc/profile_cubit/profile_state.dart';
import 'package:maydon_go/src/user/ui/home/profile_screen/profile_view_screen.dart';

import '../../../../../main.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/widgets/custom_coin.dart';
import '../../../../common/widgets/home_menu_widget.dart';
import '../../../bloc/profile_cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    context.read<ProfileCubit>().loadUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xffF2F3F5),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () => context.read<ProfileCubit>().loadUserData(),
          color: AppColors.green,
          child: ListView(
            children: [
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                if (state is ProfileLoaded) {
                  return GestureDetector(
                    onTap: () => context.pushNamed(AppRoutes.profileView),
                    child: SizedBox(
                      height: height * 0.2,
                      child: Card(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 5,
                                  color: AppColors.secondary,
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              color: AppColors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundColor: AppColors.green2,
                                backgroundImage: state.user.imageUrl != null &&
                                        state.user.imageUrl!.isNotEmpty
                                    ? NetworkImage(state.user.imageUrl!)
                                        as ImageProvider
                                    : null,
                                child: (state.user.imageUrl == null ||
                                        state.user.imageUrl!.isEmpty)
                                    ? Text(
                                        state.user.fullName!.isNotEmpty
                                            ? state.user.fullName![0]
                                                .toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      )
                                    : null,
                              ),
                              SizedBox(width: 5),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${state.user.fullName}",
                                    style: TextStyle(fontSize: height * 0.03),
                                  ),
                                  Row(
                                    spacing: 10,
                                    children: [
                                      Text(
                                        NumberFormat.decimalPattern('en')
                                            .format(state.user.point ?? 0),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: height * 0.03,
                                        ),
                                      ),
                                      CustomPaint(
                                        size: const Size(35, 35),
                                        painter: CoinPainter(),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  height: height * 0.2,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: AppColors.secondary)
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: AppColors.white),
                );
              }),
              SizedBox(height: 15),
              _listTile(
                icon: AppIcons.notificationIcon,
                title: "Notification",
                onTap: () {
                  showNotification(); // 🔔 Faqat "Notification" tanlanganda bildirishnoma keladi
                  context.pushNamed(AppRoutes.notification);
                },
                isActive: true,
              ),
              SizedBox(height: 10),
              BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
                  builder: (context, state) {
                if (state is BookingHistoryLoaded) {
                  return _listTile(
                    icon: AppIcons.stadionsIcon,
                    title: "Bookings",
                    isActive: state.bookingHistories.isNotEmpty,
                    onTap: () => context.pushNamed(AppRoutes.history),
                  );
                }
                return _listTile(
                  icon: AppIcons.stadionsIcon,
                  title: "History",
                  isActive: false,
                  onTap: () => context.pushNamed(AppRoutes.history),
                );
              }),
              SizedBox(height: 10),
              _listTile(
                icons: Icons.emoji_events_outlined,
                title: "Tournament",
                isSvg: false,
                isActive: false,
                onTap: () => context.pushNamed(AppRoutes.tournament),
              ),
              SizedBox(height: 10),
              _listTile(
                icons: Icons.lightbulb_outline,
                title: "Quizzes",
                isActive: false,
                isSvg: false,
               onTap: () => showComingSoonDialog(context),
               // onTap: () => context.pushNamed(AppRoutes.quizzes),
              ),
              SizedBox(height: 10),
              _listTile(
                icons: CupertinoIcons.money_dollar_circle,
                title: "Donation",
                isActive: false,
                isSvg: false,
                onTap: () => context.pushNamed(AppRoutes.donation),
              ),
              SizedBox(height: 10),
              _listTile(
                icons: Icons.subscriptions,
                isSvg: false,
                title: "Subscription",
                isActive: false,
                onTap: () => context.pushNamed(AppRoutes.subscription),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => UrlLauncherService.openTelegram("maydongo"),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Card(
                    color: AppColors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 15,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.group_add),
                              Text("Find people for match"),
                            ],
                          ),
                          Icon(Icons.telegram)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _listTile(
                icon: AppIcons.faqIcon,
                title: "Ilova haqida",
                isActive: false,
                onTap: () => context.pushNamed(AppRoutes.about),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _listTile({
  String? icon,
  required String title,
  required Function() onTap,
  required bool isActive,
  bool isSvg = true,
  IconData? icons,
}) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: 60,
      width: double.infinity,
      child: Card(
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 15,
            children: [
              Row(
                spacing: 10,
                children: [
                  isSvg ? SvgPicture.asset(icon!) : Icon(icons),
                  Text(title),
                ],
              ),
              Row(
                children: [
                  isActive
                      ? CircleAvatar(
                          radius: 4,
                          backgroundColor: AppColors.red,
                        )
                      : SizedBox(),
                  Icon(Icons.navigate_next),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

//TODO notificationni servicega olish kerak
Future<void> showNotification() async {
 
}

Future<void> showComingSoonDialog(BuildContext context) async {
  if (Platform.isIOS) {
    // iOS uchun Cupertino style dialog
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Tez kunda"),
        content: Text("Bu funksiya tez orada mavjud bo'ladi."),
        actions: [
          CupertinoDialogAction(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  } else {
    // Android (va boshqa) uchun Material style dialog
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tez kunda"),
        content: Text("Bu funksiya tez orada mavjud bo'ladi."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
