import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';

import '../../../common/constants/config.dart';
import '../../../common/style/app_colors.dart';

class ClubDetailScreen extends StatelessWidget {
  const ClubDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.sizeOf(context).height;
    final deviceWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tashkent Bulls"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoutes.clubTeammates),
            icon: Icon(Icons.edit),
          )
        ],
      ),
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/club_background.webp",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: deviceHeight * 0.04),
              PlayerCircleAvatar(
                deviceHeight: deviceHeight,
                position: "CF",
                user: $users[0],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "LWF",
                    user: $users[1],
                  ),
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "RWF",
                    user: $users[2],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "CMF",
                    user: $users[3],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.08,
                      ),
                      PlayerCircleAvatar(
                        deviceHeight: deviceHeight,
                        position: "DMF",
                        user: $users[4],
                      ),
                    ],
                  ),
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "CMF",
                    user: $users[5],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "LB",
                    user: $users[6],
                  ),
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "RB",
                    user: null,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "CB",
                    user: $users[8],
                  ),
                  PlayerCircleAvatar(
                    deviceHeight: deviceHeight,
                    position: "CB",
                    user: $users[9],
                  ),
                ],
              ),
              PlayerCircleAvatar(
                deviceHeight: deviceHeight,
                position: "GK",
                user: $users[10],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerCircleAvatar extends StatelessWidget {
  final double deviceHeight;
  final UserModel? user;
  final String position;

  const PlayerCircleAvatar({
    Key? key,
    required this.deviceHeight,
    this.user,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: deviceHeight * 0.05, // Radiusni kichikroq qilish
          backgroundColor: Colors.white,
          backgroundImage: (user != null && user?.imageUrl != null)
              ? NetworkImage(user!.imageUrl!)
              : null,
          child: (user == null)
              ? IconButton(
                  onPressed: () {
                    // Add your action here
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColors.green,
                    size: deviceHeight * 0.04,
                  ),
                )
              : null,
        ),
        Text(
          position,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: AppColors.white2),
        ),
      ],
    );
  }
}
