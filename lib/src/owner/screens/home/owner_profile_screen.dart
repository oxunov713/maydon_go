import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../main.dart';
import '../../../common/constants/config.dart';
import '../../../common/router/app_routes.dart';
import '../../../common/style/app_colors.dart';
import '../../../common/style/app_icons.dart';

class OwnerProfileScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              GestureDetector(
                onTap: () => context.pushNamed(AppRoutes.profileView),
                child: Container(
                  height: height * 0.2,
                  width: double.infinity,
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
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Text(
                              textAlign: TextAlign.right,
                              "sdcscds ",
                              style: TextStyle(fontSize: height * 0.03),
                            ),
                          ),
                          Text(
                            "2/30 kun",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: height * 0.03),
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
                onTap: () => context.pushNamed(AppRoutes.ownerSubs),
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
