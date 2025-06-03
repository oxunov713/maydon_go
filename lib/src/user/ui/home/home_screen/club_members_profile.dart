import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_chat_cubit.dart';
import 'package:maydon_go/src/user/bloc/team_cubit/team_cubit.dart';

import '../../../../common/model/chat_model.dart';
import '../../../../common/model/main_model.dart';
import '../../../../common/router/app_routes.dart';

class ClubProfilePage extends StatefulWidget {
  final ChatModel club;
  final UserModel currentUser;

  const ClubProfilePage({
    super.key,
    required this.club,
    required this.currentUser,
  });

  @override
  _ClubProfilePageState createState() => _ClubProfilePageState();
}

class _ClubProfilePageState extends State<ClubProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.green,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'leave_club') {
                context
                    .read<TeamCubit>()
                    .removePlayerFromPosition(widget.currentUser.id!);
              }
            },
            itemBuilder: (_) {
              final bool isOwner = context
                  .read<TeamChatCubit>()
                  .state
                  .chatModel!
                  .members
                  .any((member) =>
              member.role == 'OWNER' && member.userId == widget.currentUser.id);

              return [
                !isOwner
                    ? PopupMenuItem(
                  value: 'leave_club',
                  child: ListTile(
                    dense: true,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    visualDensity: VisualDensity.compact,
                    leading: Icon(
                      Icons.exit_to_app,
                      color: AppColors.red,
                    ),
                    title: Text(
                      'Leave Club',
                      style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                )
                    : PopupMenuItem(
                  value: 'delete_club',
                  child: ListTile(
                    dense: true,
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    visualDensity: VisualDensity.compact,
                    leading: Icon(
                      Icons.delete,
                      color: AppColors.red,
                    ),
                    title: Text(
                      'Delete Club',
                      style: TextStyle(
                          color: AppColors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 120,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.green2,
                        radius: 40,
                        child: Text(
                          widget.club.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.club.name,
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            '${widget.club.members.length} members',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: AppColors.greenDark,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    children: [
                      // Members list header
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Members",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Members list
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.club.members.length,
                          itemBuilder: (context, index) {
                            final member = widget.club.members[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.green2,
                                backgroundImage: member.userImage != null
                                    ? NetworkImage(member.userImage!)
                                    : null,
                                child: member.userImage == null
                                    ? Text(
                                  (member.userFullName ?? "M")
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                                    : null,
                              ),
                              title: Text(
                                member.userFullName ?? "Unknown",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                              "last seen recently",
                              style: const TextStyle(
                              color: Colors.white70,
                              ),
                            ),
                            trailing: Text(
                            member.role ?? "Member",
                            style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600),
                            )
                            ,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 90,
            right: 20,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue,
                  border: Border.all(color: AppColors.white, width: 2),
                ),
                child: Icon(CupertinoIcons.chat_bubble_text,
                    color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Text(
          NumberFormat.decimalPattern('en').format(int.tryParse(count)),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }
}
