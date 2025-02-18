import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import 'package:maydon_go/src/common/style/app_colors.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../common/model/userinfo_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});

  final UserInfo user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  late types.User _user;

  late types.User _otherUser;

  @override
  void initState() {
    super.initState();
    _user = types.User(
      id: '1',
      firstName: widget.user.firstName,
      lastName: widget.user.firstName,
      imageUrl: widget.user.imageUrl,
      lastSeen: DateTime.now().millisecondsSinceEpoch,
    ); // Joriy foydalanuvchi
    _otherUser = types.User(
      id: '2',
      firstName: widget.user.firstName,
      lastName: widget.user.lastName,
      imageUrl: widget.user.imageUrl,
      lastSeen: 12,
    );
    _loadFakeMessages(); // Dastlabki fake xabarlarni yuklash
  }

  String getLastSeenText(int? lastSeen) {
    if (lastSeen == null) return "Last seen recently"; // Agar noaniq bo‘lsa

    DateTime lastSeenTime = DateTime.fromMillisecondsSinceEpoch(lastSeen);
    DateTime now = DateTime.now();
    Duration diff = now.difference(lastSeenTime);

    if (diff.inMinutes < 1) {
      return "Online"; // 1 minut ichida bo‘lsa, "Online"
    } else if (diff.inMinutes < 60) {
      return "Last seen ${diff.inMinutes} minutes ago"; // Masalan, "Last seen 5 minutes ago"
    } else if (diff.inHours < 24) {
      return "Last seen at ${lastSeenTime.hour}:${lastSeenTime.minute.toString().padLeft(2, '0')}"; // Masalan, "Last seen at 14:35"
    } else {
      return "Last seen on ${lastSeenTime.day}/${lastSeenTime.month}/${lastSeenTime.year}"; // Masalan, "Last seen on 12/02/2024"
    }
  }

//TODO createdAt,Last seen,updatedAt hammasi intda keladi
  void _loadFakeMessages() {
    final messages = [
      types.TextMessage(
          author: _otherUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: '1',
          text: 'Salom! Qalaysiz?',
          status: types.Status.delivered),
      types.TextMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: '2',
          text: 'Yaxshi, sizchi?',
          status: types.Status.seen),
      types.TextMessage(
          author: _otherUser,
          createdAt: DateTime.april,
          id: '3',
          text: 'Men ham yaxshi, rahmat!',
          status: types.Status.delivered),
    ];
    setState(() {
      _messages.addAll(messages);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: message.text,
        status: types.Status.sent);

    setState(() {
      _messages.insert(0, textMessage); // Xabarni ro'yxatga qo'shish
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(CupertinoIcons.ellipsis_vertical))
        ],
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(_user.imageUrl ?? ""),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${_user.firstName!} ${_user.lastName!}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  getLastSeenText(_user.lastSeen),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: AppColors.white2),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.white2,
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        inputOptions: InputOptions(
          sendButtonVisibilityMode: SendButtonVisibilityMode.always,
        ),
        theme: DefaultChatTheme(
            inputPadding: EdgeInsets.all(0),
            messageMaxWidth: 1000,
            backgroundColor: AppColors.white2,
            primaryColor: AppColors.green,
            secondaryColor: AppColors.white,
            sentMessageBodyTextStyle: TextStyle(color: AppColors.white),
            inputMargin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            inputBorderRadius: BorderRadius.all(Radius.circular(30)),
            inputTextColor: AppColors.white,
            inputBackgroundColor: AppColors.green),
      ),
    );
  }
}
