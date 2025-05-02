import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/friend_model.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../bloc/profile_cubit/profile_state.dart';

class OtherUserProfile extends StatelessWidget {
  const OtherUserProfile(
      {super.key,
      required this.receivedUser,
      required this.currentUser,
      required this.id});

  final UserModel receivedUser;
  final UserModel currentUser;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: BlocBuilder<MyClubCubit, MyClubState>(builder: (context, state) {
          if (state is MyClubLoaded) {
            return Center(
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
                    backgroundColor: AppColors.green2,
                    backgroundImage: receivedUser.imageUrl != null &&
                            receivedUser.imageUrl!.isNotEmpty
                        ? NetworkImage(receivedUser.imageUrl!)
                        : null,
                    child: receivedUser.imageUrl == null ||
                            receivedUser.imageUrl!.isEmpty
                        ? Text(
                            (receivedUser.fullName ?? "U")
                                .substring(0, 1)
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          )
                        : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    receivedUser.fullName ?? "No name",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    receivedUser.phoneNumber ?? "55",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _card(12, "Clubs"),
                      _card(16, "Friends"),
                      _card(126, "Coins"),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: BlocBuilder<MyClubCubit, MyClubState>(
                                builder: (context, state) {
                              final isConnected = context
                                  .read<MyClubCubit>()
                                  .isConnected(receivedUser.id!);
                              return SizedBox(
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<MyClubCubit>()
                                        .toggleConnection(receivedUser);
                                  },
                                  child: Card(
                                    color: isConnected
                                        ? AppColors.grey4
                                        : AppColors.green3,
                                    child: Center(
                                      child: Text(
                                        isConnected
                                            ? "Remove from friends"
                                            : "Add to Friends",
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
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
                                      context.pushNamed(
                                        AppRoutes.chat,
                                        extra: {
                                          'chatId': id,
                                          'currentUser': types.User(
                                              id: currentUser.id.toString(),
                                              firstName: currentUser.fullName,
                                              imageUrl: currentUser.imageUrl,
                                              lastSeen: DateTime.now()
                                                  .millisecondsSinceEpoch),
                                          'receiverUser': types.User(
                                              id: receivedUser.id.toString(),
                                              firstName: receivedUser.fullName,
                                              imageUrl: receivedUser.imageUrl,
                                              lastSeen: DateTime.now()
                                                  .millisecondsSinceEpoch),
                                        },
                                      );
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
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
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

void showOtherUserProfile(BuildContext context, UserModel friend, int chatId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      final profileState = context.watch<ProfileCubit>().state;

      if (profileState is ProfileLoaded) {
        return OtherUserProfile(
          receivedUser: friend,
          id: chatId,
          currentUser: profileState.user,
        );
      }

      return const Center(child: CircularProgressIndicator());
    },
  );
}
