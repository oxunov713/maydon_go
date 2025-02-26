import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/service/url_launcher_service.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/user/ui/home/profile_view_screen.dart';

import '../../../../main.dart';
import '../../../common/style/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xffF2F3F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () => _showProfileBottomSheet(context),
                child: Container(
                  height: height * 0.2,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 5, color: AppColors.secondary)
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: AppColors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: height * 0.05,
                        backgroundImage: NetworkImage($users[2].imageUrl!),
                      ),
                      SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${$users[5].firstName!} ${$users[5].lastName!}",
                            style: TextStyle(fontSize: height * 0.03),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: height * 0.04,
                                child: Image.asset(
                                  AppIcons.mCoins,
                                ),
                              ),
                              Text(
                                "256",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: height * 0.03),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              _listTile(
                icon: AppIcons.notificationIcon,
                title: "Notification",
                onTap: () {
                  showNotification(); // 🔔 Faqat "Notification" tanlanganda bildirishnoma keladi
                  context.pushNamed(AppRoutes.notification);
                },
                isActive: true,
              ),
              _listTile(
                icon: AppIcons.stadionsIcon,
                title: "Subscription",
                isActive: false,
                onTap: () => context.pushNamed(AppRoutes.subscription),
              ),
              _listTile(
                icons: Icons.emoji_events_outlined,
                title: "Tournament",
                isSvg: false,
                isActive: false,
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text(
                          "Tez kunda...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          "Yaqin orada qo‘shiladi!",
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.pop(context);
                            },
                            child: const Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              _listTile(
                icons: Icons.lightbulb_outline,
                title: "Quizzes",
                isActive: false,
                isSvg: false,
                onTap: () => context.pushNamed(AppRoutes.quizzes),
              ),
              _listTile(
                icons: Icons.group_add,
                title: "Find people for match",
                isActive: false,
                isSvg: false,
                onTap: () => UrlLauncherService.openTelegram("maydongo"),
              ),
              _listTile(
                icon: AppIcons.settingsIcon,
                title: "Settings",
                isActive: false,
                onTap: () => context.pushNamed(AppRoutes.settings),
              ),
              _listTile(
                icon: AppIcons.historyIcon,
                title: "History",
                isActive: false,
                onTap: () => context.pushNamed(AppRoutes.history),
              ),
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

void _showProfileBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return ProfileViewScreen();
        },
      );
    },
  );
}

//TODO notificationni servicega olish kerak
Future<void> showNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id', // Unikal kanal ID
    'General Notifications', // Kanal nomi
    channelDescription: 'This channel is used for general notifications.',
    // Tavsif
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Salom!',
    'Bu lokal bildirishnoma',
    notificationDetails,
  );
}
