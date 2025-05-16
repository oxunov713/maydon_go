import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/user/bloc/chat_cubit/chat_cubit.dart';

import '../../../../common/router/app_routes.dart';
import '../../../bloc/team_cubit/team_chat_cubit.dart';

class TeamChatScreen extends StatefulWidget {
  final int chatId;

  const TeamChatScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<TeamChatScreen> createState() => _TeamChatScreenState();
}

class _TeamChatScreenState extends State<TeamChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TeamChatCubit>().joinGroupChat(widget.chatId);
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
              } else if (value == 'delete_chat') {
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
          final currentState = context.watch<ChatCubit>().state;

          return Stack(
            children: [
              if (state.status == TeamChatStatus.loading)
                const Center(child: CircularProgressIndicator()),
              if (currentState.wallpaper != null)
                Positioned.fill(
                  child: Image.asset(
                    currentState.wallpaper!,
                    fit: BoxFit.cover,
                  ),
                ),
              if (state.status == TeamChatStatus.error)
                Center(child: Text(state.errorMessage ?? 'Error loading chat'))
              else
                Column(
                  children: [
                    if (state.pinnedMessages.isNotEmpty)
                      buildPinnedMessage(
                        context,
                        state.pinnedMessages.whereType<types.TextMessage>().toList(),
                        () {},
                        () {},
                      ),
                    Expanded(
                      child: Chat(
                        messages: state.messages,
                        textMessageOptions: const TextMessageOptions(
                          isTextSelectable: false,
                        ),
                        onSendPressed: (types.PartialText message) {
                          context
                              .read<TeamChatCubit>()
                              .sendMessage(message.text);
                        },
                        onMessageTap: (context, p1) {
                          final renderBox =
                              context.findRenderObject() as RenderBox;
                          final offset = renderBox.localToGlobal(Offset.zero);
                          showTelegramStyleMenu(context, p1, offset);
                        },
                        user: state.currentUser ?? const types.User(id: '0'),
                        showUserAvatars: true,
                        showUserNames: true,
                        inputOptions: const InputOptions(
                          autofocus: false,
                          usesSafeArea: true,
                          sendButtonVisibilityMode:
                              SendButtonVisibilityMode.always,
                        ),
                        theme: DefaultChatTheme(
                          dateDividerTextStyle: TextStyle(
                            color: AppColors.white2,
                            fontWeight: FontWeight.bold,
                          ),
                          messageInsetsVertical: 10,
                          messageBorderRadius: 12,
                          messageInsetsHorizontal: 10,
                          inputPadding: EdgeInsets.zero,
                          backgroundColor: currentState.wallpaper != null
                              ? AppColors.transparent
                              : AppColors.white2,
                          primaryColor: AppColors.green,
                          secondaryColor: AppColors.white,
                          sentMessageBodyTextStyle:
                              const TextStyle(color: Colors.white),
                          receivedMessageBodyTextStyle:
                              const TextStyle(color: Colors.black),
                          inputMargin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          inputBorderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          inputTextColor: Colors.black,
                          inputBackgroundColor: Colors.white,
                          userAvatarNameColors: [AppColors.green],
                        ),
                      ),
                    ),
                  ],
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

void showTelegramStyleMenu(
    BuildContext context, types.Message message, Offset offset) async {
  // 1. Klaviaturani yopish
  FocusScope.of(context).unfocus();

  final isOwnMessage =
      message.author.id == context.read<TeamChatCubit>().currentUser.id;

  final selected = await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      offset.dx + 50,
      offset.dy,
      offset.dx + 100,
      offset.dy,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
    elevation: 8,
    items: [
      const PopupMenuItem<String>(
        value: 'pin',
        child: Row(
          children: [
            Icon(Icons.push_pin, size: 20),
            SizedBox(width: 10),
            Text("Pin qilish"),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'copy',
        child: Row(
          children: [
            Icon(Icons.copy, size: 20),
            SizedBox(width: 10),
            Text("Nusxa olish"),
          ],
        ),
      ),
      const PopupMenuItem<String>(
        value: 'forward',
        child: Row(
          children: [
            Icon(Icons.send, size: 20),
            SizedBox(width: 10),
            Text("Ulashish"),
          ],
        ),
      ),
      if (isOwnMessage)
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 20, color: Colors.red),
              SizedBox(width: 10),
              Text("O‘chirish", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
    ],
  );

  if (!context.mounted || selected == null) return;

  FocusScope.of(context).unfocus();

  switch (selected) {
    case 'pin':
      await context
          .read<TeamChatCubit>()
          .pinMessageToChat(int.parse(message.id));
      break;

    case 'copy':
      Clipboard.setData(
          ClipboardData(text: (message as types.TextMessage).text));
      break;
    case 'forward':
      // TODO: Forward qilish
      break;
    case 'delete':
      await context
          .read<TeamChatCubit>()
          .deleteMessageFromChat(int.parse(message.id));
      break;
  }
}

Widget buildPinnedMessage(
    BuildContext context,
    List<types.TextMessage> texts,
    VoidCallback onClose,
    VoidCallback onTap, // scrollToMessage chaqirilsin
    ) {
  return Material(
    color: AppColors.green40,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // 🔹 Left side - vertical bars for each pinned message
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                texts.length,
                    (index) => Container(
                  width: 4,
                  height: 8,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 🔸 Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pinned messages",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    texts.map((e) => e.text).join(" • "),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // ❌ Close icon
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: onClose,
              tooltip: "Unpin all",
            ),
          ],
        ),
      ),
    ),
  );
}

