import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/service/shared_preference_service.dart';
import 'package:maydon_go/src/user/bloc/my_club_cubit/my_club_cubit.dart';

import '../../../../common/router/app_routes.dart';
import '../../../../common/style/app_colors.dart';
import '../../../bloc/chat_cubit/chat_cubit.dart';

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
  @override
  void initState() {
    context.read<ChatCubit>().joinChat(widget.chatId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = widget.receiverUser;

    return Scaffold(
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
                backgroundImage:
                    otherUser.imageUrl != null && otherUser.imageUrl!.isNotEmpty
                        ? NetworkImage(otherUser.imageUrl!)
                        : null,
                child: otherUser.imageUrl == null || otherUser.imageUrl!.isEmpty
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
                      formatLastSeen(DateTime.now()
                          .subtract(const Duration(hours: 3))
                          .millisecondsSinceEpoch),
                      style:
                          const TextStyle(fontSize: 12, color: Colors.white70),
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
                        color: AppColors.red, fontWeight: FontWeight.w600),
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
      body: BlocBuilder<ChatCubit, ChatSState>(builder: (context, state) {
        return Stack(
          children: [
            if (state.wallpaper != null)
              Positioned.fill(
                child: Image.asset(
                  state.wallpaper!,
                  fit: BoxFit.cover,
                ),
              ),
            if (state.status == ChatStatus.loading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.green),
              )
            else if (state.status == ChatStatus.error)
              Center(child: Text('Xatolik: ${state.errorMessage}'))
            else
              Chat(
                messages: state.messages,
                onSendPressed: (partialText) {
                  context.read<ChatCubit>().sendMessage(partialText.text);
                },
                showUserAvatars: false,
                showUserNames: false,
                inputOptions: const InputOptions(
                  sendButtonVisibilityMode: SendButtonVisibilityMode.always,
                ),
                user: toTypesUser(widget.currentUser),
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
          ],
        );
      }),
    );
  }
}

types.User toTypesUser(UserModel userModel) {
  return types.User(
    id: userModel.id.toString(),
    firstName: userModel.fullName,
    imageUrl: userModel.imageUrl,
  );
}

String formatLastSeen(dynamic lastSeen) {
  if (lastSeen == null) return 'Offline';

  try {
    final date = DateTime.fromMillisecondsSinceEpoch(lastSeen);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'Online';
    if (diff.inMinutes < 60) return 'last seen ${diff.inMinutes} min ago';
    if (diff.inHours < 24) return 'last seen ${diff.inHours} h ago';

    return '${date.day}.${date.month}.${date.year}';
  } catch (e) {
    return 'Recently';
  }
}
