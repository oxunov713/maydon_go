import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/model/chat_model.dart';
import 'package:maydon_go/src/common/model/friend_model.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/router/app_routes.dart';
import 'package:maydon_go/src/common/tools/language_extension.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';

import '../../../../common/model/team_model.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/widgets/premium_widget.dart';
import '../../../bloc/user_chats_cubit/user_chats_cubit.dart';
import '../../../bloc/user_chats_cubit/user_chats_state.dart';
import 'chat_screen.dart';
import 'my_club_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    context.read<UserChatsCubit>().loadChats();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              text: 'Friends',
            ),
            Tab(text: 'Clubs'),
          ],
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Friends Tab
          _buildFriendsTab(),

          // Clubs Tab
          _buildClubsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
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
                Icons.edit,
                color: AppColors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildFriendsTab() {
    return BlocBuilder<UserChatsCubit, UserChatsState>(
        builder: (context, state) {
      if (state is UserChatsLoading) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.green,
          ),
        );
      }

      if (state is UserChatsError) {
        return Center(child: Text(state.message));
      }

      if (state is UserChatsLoaded) {
        return RefreshIndicator(
          onRefresh: () => context.read<UserChatsCubit>().loadChats(),
          color: AppColors.green,
          child: state.chats.isEmpty
              ? Center(child: Text("You have no chats yet"))
              : ListView.separated(
                  itemCount: state.chats.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.white2,
                    height: 0,
                  ),
                  itemBuilder: (context, index) {
                    final chat = state.chats[index];
                    return _buildUserTile(chat);
                  },
                ),
        );
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildClubsTab() {
    return BlocBuilder<UserChatsCubit, UserChatsState>(
      builder: (context, state) {
        if (state is UserChatsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.green,
            ),
          );
        }

        if (state is UserChatsError) {
          return Center(child: Text(state.message));
        }

        if (state is UserChatsLoaded) {
          // Filter chats to only show club chats (you might need to adjust this logic)
          final clubChats = state.clubs;

          return RefreshIndicator(
            onRefresh: () => context.read<UserChatsCubit>().loadChats(),
            color: AppColors.green,
            child: clubChats.isEmpty
                ? Center(child: Text("You have no club chats yet"))
                : ListView.separated(
                    itemCount: clubChats.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppColors.white2,
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final chat = clubChats[index];
                      return _buildClubTile(chat);
                    },
                  ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildClubTile(ChatModel chat) {
    final club = chat; // Assuming your ChatModel has a club property
    return ListTile(
      leading: _buildClubAvatar(club),
      title: Row(
        spacing: 10,
        children: [
          Icon(Icons.group),
          Text(
            club.name,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
      subtitle: Text(
        chat.lastMessage?.content.isNotEmpty == true
            ? chat.lastMessage!.content
            : "No messages yet",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color:
              chat.unreadMessages!.isNotEmpty ? Colors.black : Colors.grey[600],
          fontWeight: chat.unreadMessages!.isNotEmpty
              ? FontWeight.w500
              : FontWeight.normal,
        ),
      ),
      trailing: _buildMessageTrailing(chat.unreadMessages!),
      onTap: () {
        _navigateToClubChat(context, chat);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
    );
  }

  Widget _buildClubAvatar(ChatModel? club) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.green2,
          child: Text(
            club!.name.substring(0, 1).toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _navigateToClubChat(BuildContext context, ChatModel chat) {
    context.pushNamed(AppRoutes.teamChat, extra: chat.id);
  }

  Widget _buildUserTile(ChatModel chat) {
    final friend = chat.members.first;
    UserModel chatMemberToUserModel(ChatMember member) {
      return UserModel(
        id: member.userId,
        fullName: member.userFullName,
        phoneNumber: member.userPhoneNumber,
        imageUrl: member.userImage,
        role: member.role,
      );
    }

    return ListTile(
      leading: _buildUserAvatar(friend),
      title: Text(
        friend.userFullName ?? 'Unknown',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        chat.lastMessage?.content.isNotEmpty == true
            ? chat.lastMessage!.content
            : "Hali xabarlar yo‘q",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color:
              chat.unreadMessages!.isNotEmpty ? Colors.black : Colors.grey[600],
          fontWeight: chat.unreadMessages!.isNotEmpty
              ? FontWeight.w500
              : FontWeight.normal,
        ),
      ),
      trailing: _buildMessageTrailing(chat.unreadMessages!),
      onTap: () {
        final receiverUser = chatMemberToUserModel(friend);
        _navigateToChat(context, receiverUser, chat.id);
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }

  Widget _buildUserAvatar(ChatMember friend) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [

    CircleAvatar(
    radius: 24,
      backgroundColor: AppColors.green2,
      child: friend.userImage != null && friend.userImage!.isNotEmpty
          ? ClipOval(
        child: CachedNetworkImage(
          imageUrl: friend.userImage!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Text(
            friend.userFullName != null && friend.userFullName!.isNotEmpty
                ? friend.userFullName![0].toUpperCase()
                : '?',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      )
          : Text(
        friend.userFullName != null && friend.userFullName!.isNotEmpty
            ? friend.userFullName![0].toUpperCase()
            : '?',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
      ),
    )
,
    Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.grey4,
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

  Widget _buildMessageTrailing(List<ChatMessage> messages) {
    return (messages.isNotEmpty)
        ? CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.green,
            child: Text(
              messages.length.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : SizedBox();
  }

  void _navigateToChat(
      BuildContext context, UserModel receiverUser, int chatId) {
    final user = context.read<MyClubCubit>().user;

    context.pushNamed(
      AppRoutes.chat,
      extra: {
        'currentUser': user,
        'receiverUser': receiverUser,
        "chatId": chatId
      },
    );
  }
}

// Rest of your code (UserSearchDelegate) remains the same...
class UserSearchDelegate extends SearchDelegate<String> {
  final MyClubCubit myClubCubit;
  Timer? _debounce;

  UserSearchDelegate(this.myClubCubit)
      : super(keyboardType: TextInputType.number);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        shadowColor: Colors.transparent,
      ),
      textTheme: const TextTheme(titleLarge: TextStyle(color: Colors.white)),
      textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white, selectionColor: AppColors.grey4),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.green,
        hintStyle: TextStyle(color: Colors.white70),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.green,
          ), // Aktiv chiziq
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.white70, width: 1), // Normal chiziq
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          if (query.isEmpty) {
            FocusScope.of(context).unfocus();
          } else {
            // Matnni tozalaydi
            query = '';
            showSuggestions(context); // Suggestion’ni qayta chizish
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildUserList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      myClubCubit.searchUsers(query);
    });

    return ColoredBox(color: AppColors.white2, child: _buildUserList());
  }

  Widget _buildUserList() {
    return BlocBuilder<MyClubCubit, MyClubState>(
      bloc: myClubCubit,
      builder: (context, state) {
        if (state is MyClubLoaded) {
          final results = state.searchResults;
          if (results.isEmpty) {
            return const Center(child: Text("No results found"));
          }

          final connectedUsers = results
              .where((user) => myClubCubit.isConnected(user.id!))
              .toList();
          final notConnectedUsers = results
              .where((user) => !myClubCubit.isConnected(user.id!))
              .toList();

          final sortedUsers = [...connectedUsers, ...notConnectedUsers];

          return ListView.builder(
            itemCount: sortedUsers.length,
            itemBuilder: (context, index) {
              final user = sortedUsers[index];
              final isConnected = myClubCubit.isConnected(user.id!);

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.green2,

                  backgroundImage:
                      user.imageUrl != null && user.imageUrl!.isNotEmpty
                          ? NetworkImage(user.imageUrl!)
                          : null,

                  child: user.imageUrl == null || user.imageUrl!.isEmpty
                      ? Text(
                          (user.fullName ?? "U").substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null, // Rasm bor bo‘lsa, `child` ko‘rinmasligi kerak
                ),
                title: Text(user.fullName ?? "No Name"),
                subtitle: Text(user.phoneNumber ?? ""),
                trailing: IconButton(
                  icon: Icon(
                    isConnected ? Icons.person_remove : Icons.person_add,
                    color: isConnected ? Colors.red : Colors.green,
                  ),
                  onPressed: () {
                    final subName =
                        state.user.subscriptionModel?.name ?? "Free";
                    final maxAllowed = subName == "Go+"
                        ? GoPlusSubscriptionFeatures.friendsLength
                        : subName == "Go"
                            ? GoSubscriptionFeatures.friendsLength
                            : 1;
                    final currentConnections = state.connections.length;

                    if (!isConnected && currentConnections >= maxAllowed) {
                      showBuyPremiumBottomSheet(context);
                    } else {
                      myClubCubit.toggleConnection(user);
                    }
                  },
                ),
              );
            },
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: AppColors.green,
        ));
      },
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
