import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: AppColors.secondary),
              ),
              SizedBox(height: 30),
              CircleAvatar(
                radius: 70,
                backgroundColor: AppColors.white2,
                backgroundImage: NetworkImage(user.imageUrl!),
              ),
              SizedBox(height: 20),
              Text(
                user.firstName! + "  " + user.lastName!,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              Text(
                user.contactNumber!,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _card(2, "Clubs"),
                  _card(16, "Friends"),
                  _card(126, "Coins"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 60,
                            child: GestureDetector(
                              onTap: () {
                                //add or remove from friends
                              },
                              child: Card(
                                color: AppColors.green3,
                                child: Center(
                                  child: Text(
                                    "Add to Friends",
                                    style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 60,
                            child: Card(
                              color: AppColors.green3,
                              child: SizedBox(
                                height: 10,
                                width: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    //disable if user haven't go+
                                    context.pushNamed(AppRoutes.chat,
                                        extra: user);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: SvgPicture.asset(
                                      AppIcons.chatIcon,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _card(int number, String title) {
  return SizedBox(
    height: 100,
    width: 100,
    child: Card(
      color: AppColors.white2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            number.toString(),
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppColors.main),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.main),
          ),
        ],
      ),
    ),
  );
}
