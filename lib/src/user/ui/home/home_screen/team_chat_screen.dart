import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:maydon_go/src/common/widgets/chat_shimmer.dart';
import 'package:maydon_go/src/common/widgets/message_option.dart';
import 'package:maydon_go/src/user/bloc/chat_cubit/chat_cubit.dart';
import 'package:maydon_go/src/user/ui/home/home_screen/club_members_profile.dart';

import '../../../../common/model/chat_model.dart';
import '../../../../common/router/app_routes.dart';
import '../../../../common/style/app_icons.dart';
import '../../../../common/widgets/chat_text_field.dart';
import '../../../../common/widgets/pinned_messages.dart';
import '../../../bloc/pinned_messages/pinned_messages_cubit.dart';
import '../../../bloc/team_cubit/team_chat_cubit.dart';
import '../../../bloc/user_chats_cubit/user_chats_cubit.dart';

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
  late final ScrollController _scrollController;
  late final TextEditingController _textController;
  late final FocusNode _messageFocusNode;
  final Map<String, GlobalKey> _messageKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    _messageFocusNode = FocusNode();
    context.read<TeamChatCubit>().joinGroupChat(widget.chatId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TeamChatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.chatId != widget.chatId) {
      context.read<TeamChatCubit>().joinGroupChat(widget.chatId);
    }
  }

  String _formatMessageTime(DateTime sentAt) {
    return '${sentAt.hour.toString().padLeft(2, '0')}:${sentAt.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToMessage(String messageId) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _messageKeys[messageId];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
      }
    });
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    bool isCurrentUser,
    BuildContext context,
  ) {
    final messageKey = _messageKeys.putIfAbsent(
      message.id.toString(),
      () => GlobalKey(),
    );

    final chatState = context.read<TeamChatCubit>().state;
    final sender = chatState.members.firstWhere(
      (member) => member.userId == message.senderId,
      orElse: () => MemberModel(
        id: 0,
        userId: message.senderId,
        username: 'Unknown',
        userImage: '',
        joinedAt: DateTime.now(),
        position: '',
      ),
    );

    return GestureDetector(
      onTapDown: (details) {
        final offset = details.globalPosition;
        showMessageOptions(
          context: context,
          message: message,
          offset: offset,
          currentUserId: chatState.currentUser?.id.toString() ?? '',
          pinnedMessages: chatState.pinnedMessages,
          deleteFunction: () async {
            await context
                .read<TeamChatCubit>()
                .deleteMessageFromChat(message.id);
          },
          pinFunction: () async {
            await context.read<TeamChatCubit>().pinMessageToChat(message.id);
          },
          unpinFunction: () async {
            await context
                .read<TeamChatCubit>()
                .unpinMessageFromChat(message.id);
          },
          forwardFunction: () async {
            // optional
          },
        );
      },
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: sender.userImage!.isNotEmpty
                    ? NetworkImage(sender.userImage!)
                    : AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Container(
              key: messageKey,
              margin: const EdgeInsets.only(top: 6, bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isCurrentUser ? AppColors.green : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isCurrentUser ? 12 : 0),
                  bottomRight: Radius.circular(isCurrentUser ? 0 : 12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isCurrentUser && chatState.members.length > 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        sender.username,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          message.content,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Nunito",
                            color: isCurrentUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatMessageTime(message.sentAt),
                        style: TextStyle(
                          fontSize: 10,
                          color: isCurrentUser
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeamChatCubit, TeamChatState>(
      listener: (context, state) {
        if (ChatStatus.loaded == state.status && state.messages.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        }
      },
      builder: (context, state) {
        final chatState = context.watch<ChatCubit>().state;
        if (state.status == ChatStatus.loading) {
          return buildLoadingUI();
        }

        if (state.status == ChatStatus.error) {
          return Center(child: Text('Xatolik: ${state.errorMessage}'));
        }
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) async {
            await context.read<UserChatsCubit>().loadChats();
            return;
          },
          child: Scaffold(
            appBar: AppBar(
              title: BlocBuilder<TeamChatCubit, TeamChatState>(
                builder: (context, state) {
                  return InkWell(
                    splashColor: AppColors.transparent,
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.clubProfile,
                        extra: {'club': state.chatModel},
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.groupName ?? 'Loading...',
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
                    ),
                  );
                },
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'wallpaper') {
                      context.pushNamed(AppRoutes.wallpaper);
                    } else if (value == 'delete_chat') {
                      context.read<TeamChatCubit>().deleteChat();
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
                            color: AppColors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      if (chatState.wallpaper != null)
                        Positioned.fill(
                          child: Image.asset(
                            chatState.wallpaper!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (chatState.wallpaper == null)
                        Positioned.fill(
                          child: Image.asset(
                            AppIcons.chatWall2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (state.messages.isNotEmpty)
                        Column(
                          children: [
                            if (state.pinnedMessages.isNotEmpty)
                              PinnedMessagesHeader(
                                pinnedMessages:
                                    state.pinnedMessages.cast<ChatMessage>(),
                                onClose: () {},
                                onPinTap: (index) {
                                  _scrollToMessage(
                                      state.pinnedMessages[index].id.toString());
                                },
                                onExpandToggle: () {},
                                cubit: PinnedMessagesCubit(),
                              ),
                            Expanded(
                              child: ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                itemCount: state.messages.length,
                                itemBuilder: (context, index) {
                                  final message = state.messages[
                                      state.messages.length - 1 - index];
                                  final isCurrentUser =
                                      state.currentUser!.id == message.senderId;

                                  return _buildMessageBubble(
                                      message, isCurrentUser, context);
                                },
                              ),
                            ),
                          ],
                        ),
                      if (state.messages.isEmpty)
                        Center(
                          child: Text(
                            "Sizda hozircha xabarlar yo'q.",
                            style: TextStyle(color: AppColors.white),
                          ),
                        )
                    ],
                  ),
                ),
                ChatInputField(
                  isPrivateChat: false,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
