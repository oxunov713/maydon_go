import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';

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
        title: Text("Profile"),
      ),
      backgroundColor: Color(0xffF2F3F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 10,
            children: [
              Container(
                height: height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: AppColors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: height * 0.05,
                      backgroundImage: NetworkImage($users[5].imageUrl!),
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
              _listTile(AppIcons.notificationIcon, "Notification"),
              _listTile(AppIcons.stadionsIcon, "Subscription"),
              _listTile(AppIcons.settingsIcon, "Settings"),
              _listTile(AppIcons.historyIcon, "History"),
              _listTile(AppIcons.faqIcon, "F.A.Q"),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _listTile(String icon, String title) {
  return ListTile(
    tileColor: AppColors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
    leading: SvgPicture.asset(icon),
    title: Text(title),
    trailing: IconButton(onPressed: () {}, icon: Icon(Icons.navigate_next)),
  );
}
