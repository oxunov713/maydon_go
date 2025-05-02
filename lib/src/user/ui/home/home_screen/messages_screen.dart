import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/model/friend_model.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../../../common/style/app_colors.dart';
import '../../../../common/widgets/premium_widget.dart';
import 'chat_screen.dart';
import 'my_club_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late List<Friendship> friendsMessages;

  late final List<ChatUser> _users;

  @override
  void initState() {
    super.initState();

    friendsMessages = context.read<MyClubCubit>().connections;

    _users = friendsMessages.map((friendship) {
      return ChatUser(
        user: friendship.friend,
        lastMessage: "No messages yet",
        time: _formatTime(DateTime.now()),
        isOnline: true,
        unreadCount: 0,
      );
    }).toList();
  }

  String _formatTime(DateTime? time) {
    if (time == null) return "Just now";

    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inHours < 1) return "${difference.inMinutes}m ago";
    if (difference.inDays < 1) return "${difference.inHours}h ago";
    if (difference.inDays < 7) return "${difference.inDays}d ago";

    return "${time.day}/${time.month}/${time.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: BlocBuilder<MyClubCubit, MyClubState>(
                builder: (context, state) {
              if (state is MyClubLoaded) {
                final isPremium = state.user.subscriptionModel?.name == "Go+";
                final maxLength = isPremium
                    ? GoPlusSubscriptionFeatures.friendsLength
                    : GoSubscriptionFeatures.friendsLength;
                return Text("${state.connections.length}/$maxLength");
              } else if (state is MyClubLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MyClubError) {
                return ListView(
                    padding: EdgeInsets.only(top: 250),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Text(
                            "Xatolik yuz berdi, iltimos qayta urinib ko‘ring."),
                      )
                    ]);
              }
              return Center(
                child: Text(context.lan.noData),
              );
            }),
          )
        ],
      ),
      body: (_users.isNotEmpty)
          ? _buildMessagesList()
          : Center(
              child: Text(
                "You have no chats yet.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        shape: CircleBorder(),
        onPressed: () {
          final state = context.read<MyClubCubit>().state;
          if (state is MyClubLoaded) {
            final isPremium = state.user.subscriptionModel?.name == "Go+";
            final maxLength = isPremium
                ? GoPlusSubscriptionFeatures.friendsLength
                : GoSubscriptionFeatures.friendsLength;
            if (state.connections.length >= maxLength) {
              showBuyPremiumBottomSheet(context);
            } else {
              showSearch(
                context: context,
                delegate: UserSearchDelegate(
                  context.read<MyClubCubit>(),
                ),
              );
            }
          }
        },
        child: const Icon(
          Icons.edit,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final chatUser = _users[index];
        return _buildUserTile(chatUser);
      },
    );
  }

  Widget _buildUserTile(ChatUser chatUser) {
    final friend = chatUser.user;
    return ListTile(
      leading: _buildUserAvatar(friend),
      title: Text(
        friend.fullName ?? 'Unknown',
        style: TextStyle(
          fontWeight:
              chatUser.unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        chatUser.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: chatUser.unreadCount > 0 ? Colors.black : Colors.grey[600],
          fontWeight:
              chatUser.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: _buildMessageTrailing(chatUser),
      onTap: () => _navigateToChat(context, friend),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    );
  }

  Widget _buildUserAvatar(UserModel friend) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.green2,
          backgroundImage:
              friend.imageUrl != null && friend.imageUrl!.isNotEmpty
                  ? NetworkImage(friend.imageUrl!) as ImageProvider
                  : null,
          child: (friend.imageUrl == null || friend.imageUrl!.isEmpty)
              ? Text(
                  friend.fullName != null && friend.fullName!.isNotEmpty
                      ? friend.fullName![0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                )
              : null,
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.green3,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageTrailing(ChatUser chatUser) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          chatUser.time,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        if (chatUser.unreadCount > 0)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: Text(
              chatUser.unreadCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  void _navigateToChat(BuildContext context, UserModel friend) {
    // context.pushNamed(
    //   AppRoutes.chat,
    //   extra: {
    //     'currentUser': types.User(
    //       id: currentUser.id.toString(),
    //       firstName: currentUser.fullName,
    //     ),
    //     'receiverUser': types.User(
    //       id: user.id.toString(),
    //       firstName: user.fullName,
    //     ),
    //   },
    // );
  }
}

class ChatUser {
  final UserModel user;
  final String lastMessage;

  final String time;
  final bool isOnline;
  final int unreadCount;

  ChatUser({
    required this.user,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    required this.unreadCount,
  });
}
