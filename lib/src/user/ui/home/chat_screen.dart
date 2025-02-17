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

  @override
  void initState() {
    super.initState();
    _loadFakeMessages(); // Dastlabki fake xabarlarni yuklash
  }

  final _user = const types.User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
  ); // Joriy foydalanuvchi
  final _otherUser = const types.User(
    id: '2',
    firstName: 'Jane',
    lastName: 'Doe',
  ); // Qar
  void _loadFakeMessages() {
    final messages = [
      types.TextMessage(
        author: _otherUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '1',
        text: 'Salom! Qalaysiz?',
      ),
      types.TextMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '2',
        text: 'Yaxshi, sizchi?',
      ),
      types.TextMessage(
        author: _otherUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '3',
        text: 'Men ham yaxshi, rahmat!',
      ),
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
    );

    setState(() {
      _messages.insert(0, textMessage); // Xabarni ro'yxatga qo'shish
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.user.imageUrl!,
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.user.firstName!} ${widget.user.lastName!}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  widget.user.contactNumber!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: AppColors.white2),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.ellipsis_vertical),
            onPressed: () {
              // Action yozish
            },
          )
        ],
      ),
      backgroundColor: AppColors.white2,
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }
}
