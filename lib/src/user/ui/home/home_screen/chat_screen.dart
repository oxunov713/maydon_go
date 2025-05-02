import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/constants/config.dart';

import '../../../../common/style/app_colors.dart';
import '../../../bloc/chat_cubit/chat_cubit.dart';
import '../../../bloc/chat_cubit/chat_state.dart';

class ChatScreen extends StatefulWidget {
  final types.User currentUser;
  final types.User receiverUser;
  final int chatId;

  const ChatScreen(
      {required this.currentUser,
      required this.receiverUser,
      required this.chatId,
      super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final otherUser = widget.receiverUser;
    return BlocProvider(
      create: (context) => ChatCubit(
        serverUrl: Config.wsServerUrl,
        currentUser: widget.currentUser,
      )..joinChat(widget.chatId),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            spacing: 15,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.green2,
                backgroundImage:
                    otherUser.imageUrl != null && otherUser.imageUrl!.isNotEmpty
                        ? NetworkImage(otherUser.imageUrl!)
                        : null,

                child: otherUser.imageUrl == null || otherUser.imageUrl!.isEmpty
                    ? Text(
                        (otherUser.firstName ?? "U")
                            .substring(0, 1)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null, // Rasm bor bo‘lsa, `child` ko‘rinmasligi kerak
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      otherUser.firstName ?? "No name",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      _formatLastSeen(otherUser.lastSeen),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
        ),
        body: BlocBuilder<ChatCubit, ChatSState>(
          builder: (context, state) {
            return Expanded(
              child: Chat(
                messages: state.messages,
                onSendPressed: (partialText) {
                  context.read<ChatCubit>().sendMessage(
                        partialText.text,
                      );
                },
                showUserAvatars: true,
                showUserNames: true,
                inputOptions: const InputOptions(
                  sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                ),
                user: widget.currentUser,
                theme: DefaultChatTheme(
                  inputPadding: EdgeInsets.zero,
                  backgroundColor: AppColors.white2,
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
            );
          },
        ),
      ),
    );
  }
}

String _formatLastSeen(dynamic lastSeen) {
  if (lastSeen == null) return 'Offline';

  try {
    final date = DateTime.fromMillisecondsSinceEpoch(lastSeen);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Online';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';

    return '${date.day}.${date.month}.${date.year}';
  } catch (e) {
    return 'Recently';
  }
}
