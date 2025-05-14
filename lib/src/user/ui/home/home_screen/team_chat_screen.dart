import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';

import '../../../../common/router/app_routes.dart';
import '../../../bloc/my_club_cubit/my_club_cubit.dart';
import '../../../bloc/team_cubit/team_chat_cubit.dart';

class TeamChatScreen extends StatefulWidget {
  final int teamId;

  const TeamChatScreen({
    super.key,
    required this.teamId,
  });

  @override
  State<TeamChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends State<TeamChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamChatCubit>().joinGroupChat(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<TeamChatCubit, TeamChatState>(
            builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.groupName ?? 'Loading...', // Safe fallback
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.members.length} people',
                style: TextStyle(fontSize: 12, color: AppColors.white2),
              ),
            ],
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              _showTeamSheet(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'wallpaper') {
                context.pushNamed(AppRoutes.wallpaper);
              }  else if (value == 'delete_chat') {
                //context.read<ChatCubit>().deleteChat();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'wallpaper',
                child: ListTile(
                  dense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.collections),
                  title: Text(
                    'Change Wallpaper',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              PopupMenuItem(
                value: 'delete_chat',
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
                    'History clear',
                    style: TextStyle(
                        color: AppColors.red, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TeamChatCubit, TeamChatState>(
        builder: (context, state) {
          if (state.status == TeamChatStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TeamChatStatus.error) {
            return Center(
                child: Text(state.errorMessage ?? 'Error loading chat'));
          }

          return Stack(
            children: [
              BlocBuilder<TeamChatCubit, TeamChatState>(
                  builder: (context, state) {
                return Positioned.fill(
                    child: Image.asset(
                  state.wallpaper != null
                      ? state.wallpaper!
                      : AppIcons.chatWall1,
                  fit: BoxFit.cover,
                ));
              }),
              Expanded(
                child: Chat(
                  messages: state.messages,
                  onSendPressed: (types.PartialText message) {
                    context.read<TeamChatCubit>().sendMessage(message.text);
                  },
                  user: state.currentUser!,
                  showUserAvatars: true,
                  showUserNames: true,
                  inputOptions: const InputOptions(
                    sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                  ),
                  theme: DefaultChatTheme(
                    dateDividerTextStyle: TextStyle(
                        color: AppColors.white2, fontWeight: FontWeight.bold),
                    messageInsetsVertical: 8,
                    messageBorderRadius: 15,
                    messageInsetsHorizontal: 10,
                    inputPadding: EdgeInsets.zero,
                    backgroundColor: state.wallpaper != null
                        ? AppColors.transparent
                        : AppColors.white2,
                    primaryColor: AppColors.green,
                    secondaryColor: AppColors.white,
                    sentMessageBodyTextStyle:
                        const TextStyle(color: Colors.white),
                    receivedMessageBodyTextStyle:
                        const TextStyle(color: Colors.black),
                    inputMargin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    inputBorderRadius:
                        const BorderRadius.all(Radius.circular(30)),
                    inputTextColor: Colors.black,
                    inputBackgroundColor: Colors.white,
                    userAvatarNameColors: [AppColors.green],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTeamSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocBuilder<TeamChatCubit, TeamChatState>(
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Team Members (${state.members.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // Implement add member functionality
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.members.length,
                      itemBuilder: (context, index) {
                        final member = state.members[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.green,
                            backgroundImage: member.imageUrl != null
                                ? NetworkImage(member.imageUrl!)
                                : null,
                            child: member.imageUrl == null
                                ? Text(member.firstName?[0] ?? '?')
                                : null,
                          ),
                          title: Text(member.firstName ?? 'Unknown'),
                          subtitle: Text('Member'),
                          trailing: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              _showMemberOptions(context, member);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMemberOptions(BuildContext context, types.User member) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Profile'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement view profile
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Send Private Message'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement private message
                },
              ),
              if (member.id !=
                  context.read<TeamChatCubit>().currentUser.id) // Not self
                ListTile(
                  leading: const Icon(Icons.remove_circle_outline),
                  title: const Text('Remove from Team'),
                  onTap: () {
                    // Navigator.pop(context);
                    // context
                    //     .read<TeamChatCubit>()
                    //     .removeMemberFromGroup(int.parse(member.id));
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
