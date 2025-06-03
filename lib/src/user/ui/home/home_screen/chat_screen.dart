import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/model/chat_model.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/service/shared_preference_service.dart';
import 'package:maydon_go/src/common/style/app_icons.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';
import 'package:maydon_go/src/common/widgets/chat_shimmer.dart';
import 'package:maydon_go/src/user/bloc/chat_cubit/chat_cubit.dart';
import 'package:maydon_go/src/user/bloc/pinned_messages/pinned_messages_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import '../../../../common/router/app_routes.dart';
import '../../../../common/style/app_colors.dart';
import '../../../../common/widgets/chat_text_field.dart';
import '../../../../common/widgets/message_option.dart';
import '../../../../common/widgets/pinned_messages.dart';
import '../../../bloc/user_chats_cubit/user_chats_cubit.dart';

class ChatScreen extends StatefulWidget {
  final UserModel currentUser;
  final UserModel receiverUser;
  final int chatId;

  const ChatScreen({
    required this.currentUser,
    required this.receiverUser,
    required this.chatId,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
    context.read<ChatCubit>().joinChat(widget.chatId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  // 1. Update the scrollToMessage function to handle cases where the message isn't immediately available
  void _scrollToMessage(String messageId) {
    // First try immediately
    _tryScrollToMessage(messageId);

    // Then set up a retry mechanism in case the message isn't rendered yet
    int retryCount = 0;
    final maxRetries = 3;
    final retryDelay = const Duration(milliseconds: 200);

    Future<void> retryScroll() async {
      await Future.delayed(retryDelay);
      if (!_tryScrollToMessage(messageId) && retryCount < maxRetries) {
        retryCount++;
        retryScroll();
      }
    }

    retryScroll();
  }

  bool _tryScrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.3,
      );
      return true;
    }
    return false;
  }

  Widget _buildMessageBubble(ChatMessage message, bool isCurrentUser) {
    final key = _messageKeys.putIfAbsent(
      message.id.toString(),
      () => GlobalKey(),
    );

    return GestureDetector(
      onTapDown: (details) {
        final offset = details.globalPosition;
        final chatState = context.read<ChatCubit>().state;
        showMessageOptions(
          context: context,
          message: message,
          offset: offset,
          currentUserId: widget.currentUser.id.toString(),
          pinnedMessages: chatState.pinnedMessages ?? [],
          deleteFunction: () async {
            await context.read<ChatCubit>().deleteMessage(message.id);
          },
          pinFunction: () async {
            await context.read<ChatCubit>().pinMessage(message.id);
          },
          unpinFunction: () async {
            await context.read<ChatCubit>().unpinMessage(message.id);
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Container(
              key: key,
              margin: const EdgeInsets.only(bottom: 6),
              // Removed top margin to prevent double spacing
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

  String _formatMessageTime(DateTime sentAt) {
    return '${sentAt.hour.toString().padLeft(2, '0')}:${sentAt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = widget.receiverUser;

    return BlocConsumer<ChatCubit, ChatSState>(
      listener: (context, state) {
        if (state.status == ChatStatus.loaded && state.messages.isNotEmpty) {
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
              title: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.profileChat,
                    extra: {
                      'receivedUser': widget.receiverUser,
                      'chatId': widget.chatId,
                    },
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: AppColors.green2,
                      backgroundImage: otherUser.imageUrl != null &&
                              otherUser.imageUrl!.isNotEmpty
                          ? NetworkImage(otherUser.imageUrl!)
                          : null,
                      child: otherUser.imageUrl == null ||
                              otherUser.imageUrl!.isEmpty
                          ? Text(
                              (otherUser.fullName ?? "U")
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            otherUser.fullName ?? "No name",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "last seen recently",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'wallpaper') {
                      context.pushNamed(AppRoutes.wallpaper);
                    } else if (value == 'remove_friend') {
                      context.goNamed(AppRoutes.home);
                      context
                          .read<MyClubCubit>()
                          .removeConnection(widget.receiverUser);
                    } else if (value == 'delete_chat') {
                      context.read<ChatCubit>().deleteChat();
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
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
                    const PopupMenuItem(
                      value: 'remove_friend',
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        visualDensity: VisualDensity.compact,
                        leading: Icon(
                          Icons.person_remove,
                          color: AppColors.red,
                        ),
                        title: Text(
                          'Remove Friend',
                          style: TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const PopupMenuItem(
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
                              fontWeight: FontWeight.w600),
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
                      if (state.wallpaper != null)
                        Positioned.fill(
                          child: Image.asset(
                            state.wallpaper!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (state.wallpaper == null)
                        Positioned.fill(
                          child: Image.asset(
                            AppIcons.chatWall2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (state.messages.isNotEmpty)
                        Column(
                          children: [
                            if (state.pinnedMessages!.isNotEmpty)
                              PinnedMessagesHeader(
                                pinnedMessages:
                                    state.pinnedMessages!.cast<ChatMessage>(),
                                onClose: () {},
                                onPinTap: (index) {

                                },
                                onExpandToggle: () {},
                                cubit: PinnedMessagesCubit(),
                              ),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return ListView.builder(
                                    controller: _scrollController,
                                    reverse: true,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    itemCount: state.messages.length,
                                    itemBuilder: (context, index) {
                                      final message = state.messages[index];
                                      final isCurrentUser =
                                          widget.currentUser.id ==
                                              message.senderId;
                                      return _buildMessageBubble(
                                          message, isCurrentUser);
                                    },
                                  );
                                },
                              ),
                            )
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
                  isPrivateChat: true,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
