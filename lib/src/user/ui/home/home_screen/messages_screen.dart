import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
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

  late final List<Friendship> _users;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentState = context.read<MyClubCubit>().state;
    if (currentState is MyClubLoaded) {
      _users = currentState.connections;
    }
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
                return const Center(
                    child: SizedBox.square(
                        dimension: 10,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        )));
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
      body: BlocBuilder<MyClubCubit, MyClubState>(

          builder: (context, state) {
            if (state is MyClubLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: AppColors.green,
              ),);
            }

            if (state is MyClubError) {
              return Center(child: Text(state.error));
            }

            if (state is MyClubLoaded) {
              final users = state.connections;

              return RefreshIndicator(
                onRefresh: () => context.read<MyClubCubit>().loadData(),
                child: users.isEmpty
                    ? Center(child: Text("You have no chats yet"))
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final chatUser = users[index];
                          return _buildUserTile(chatUser);
                        },
                      ),
              );
            }

            return const SizedBox.shrink();
          }),
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
        child: Icon(
          (_users.isNotEmpty) ? Icons.edit : Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildUserTile(Friendship chatUser) {
    final friend = chatUser.friend;
    return ListTile(
      leading: _buildUserAvatar(friend),
      title: Text(
        friend.fullName ?? 'Unknown',
        style: TextStyle(
          fontWeight: (friend.unreadCount ?? 0) > 0
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        friend.lastMessage.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color:
              (friend.unreadCount ?? 0) > 0 ? Colors.black : Colors.grey[600],
          fontWeight: (friend.unreadCount ?? 0) > 0
              ? FontWeight.w500
              : FontWeight.normal,
        ),
      ),
      trailing: _buildMessageTrailing(chatUser),
      onTap: () => _navigateToChat(context, chatUser),
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

  Widget _buildMessageTrailing(Friendship chatUser) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          chatUser.friend.time ?? "0",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        if ((chatUser.friend.unreadCount ?? 0) > 0)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: Text(
              chatUser.friend.unreadCount.toString(),
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

  void _navigateToChat(BuildContext context, Friendship friend) {
    final user = context.read<MyClubCubit>().user;

    context.pushNamed(
      AppRoutes.chat,
      extra: {
        'currentUser': user,
        'receiverUser': friend.friend,
        "chatId": friend.chatId
      },
    );
  }
}
