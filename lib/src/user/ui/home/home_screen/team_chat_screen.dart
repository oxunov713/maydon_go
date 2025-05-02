import 'package:flutter/material.dart';

import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:maydon_go/src/common/model/team_model.dart';

import 'package:maydon_go/src/common/style/app_colors.dart';

class TeamChatScreen extends StatefulWidget {
  final String teamName;

  final String teamLogo;

  const TeamChatScreen({
    super.key,
    required this.teamName,
    required this.teamLogo,
  });

  @override
  State<TeamChatScreen> createState() => _FootballTeamChatScreenState();
}

class _FootballTeamChatScreenState extends State<TeamChatScreen> {
  final List<types.Message> _messages = [];

  late types.User _currentUser;

  final List<TeamMember> _players = [];

  @override
  void initState() {
    super.initState();

    _initializeUsers();

    _loadFakeMessages();

    _initializeTeam();
  }

  void _initializeUsers() {
    _currentUser = types.User(
      id: 'current_user',
      firstName: 'You',
      imageUrl: 'https://example.com/your_photo.jpg',
    );
  }

  void _initializeTeam() {
// Starting 11 with standard positions (4-3-3 formation)

    _players.addAll([
      TeamMember(id: '1', name: 'David De Gea', position: 'GK', photoUrl: ''),
      TeamMember(
          id: '2',
          name: 'Trent Alexander-Arnold',
          position: 'RB',
          photoUrl: ''),
      TeamMember(
          id: '3', name: 'Virgil van Dijk', position: 'CB', photoUrl: ''),
      TeamMember(id: '4', name: 'Rúben Dias', position: 'CB', photoUrl: ''),
      TeamMember(
          id: '5', name: 'Andrew Robertson', position: 'LB', photoUrl: ''),
      TeamMember(
          id: '6', name: 'Kevin De Bruyne', position: 'CMF', photoUrl: ''),
      TeamMember(id: '7', name: 'N\'Golo Kanté', position: 'DMF', photoUrl: ''),
      TeamMember(id: '8', name: 'Luka Modrić', position: 'CMF', photoUrl: ''),
      TeamMember(id: '9', name: 'Mohamed Salah', position: 'RWF', photoUrl: ''),
      TeamMember(
          id: '10', name: 'Robert Lewandowski', position: 'CF', photoUrl: ''),
      TeamMember(
          id: '11', name: 'Kylian Mbappé', position: 'LWF', photoUrl: ''),
    ]);
  }

  void _loadFakeMessages() {
    final messages = [
      types.TextMessage(
        author: types.User(id: 'coach', firstName: 'Coach'),
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 2))
            .millisecondsSinceEpoch,
        id: '1',
        text: 'Team meeting at 18:00 before the match',
      ),
      types.TextMessage(
        author: types.User(id: 'ss', firstName: 'Azizbek Oxunov'),
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 2))
            .millisecondsSinceEpoch,
        id: '5',
        text: 'Go boys!!!!',
      ),
      types.TextMessage(
        author: _currentUser,
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 1))
            .millisecondsSinceEpoch,
        id: '2',
        text: 'I\'ll be there. Working on set pieces today',
      ),
      types.TextMessage(
        author: types.User(id: 'captain', firstName: 'Virgil'),
        createdAt: DateTime.now()
            .subtract(const Duration(minutes: 30))
            .millisecondsSinceEpoch,
        id: '3',
        text: 'Don\'t forget to bring both kits - home and away',
      ),
    ];

    setState(() {
      _messages.addAll(messages.reversed);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _currentUser,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.teamName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '4-3-3 Formation',
              style: TextStyle(fontSize: 12, color: AppColors.white2),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              _showTeamSheet(context);
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit formation"),
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text("Match reminders"),
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text("Clear chat"),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: _currentUser,
              showUserAvatars: true,
              showUserNames: true,
              inputOptions: const InputOptions(
                sendButtonVisibilityMode: SendButtonVisibilityMode.always,
              ),
              theme: DefaultChatTheme(
                inputPadding: EdgeInsets.zero,
                backgroundColor: AppColors.white2,
                primaryColor: AppColors.green,
                secondaryColor: AppColors.white,
                sentMessageBodyTextStyle: const TextStyle(color: Colors.white),
                receivedMessageBodyTextStyle:
                    const TextStyle(color: Colors.black),
                inputMargin:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                inputBorderRadius: const BorderRadius.all(Radius.circular(30)),
                inputTextColor: Colors.black,
                inputBackgroundColor: Colors.white,
                userAvatarNameColors: [AppColors.green],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTeamSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Starting XI',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _players.length,
                  itemBuilder: (context, index) {
                    final player = _players[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.green,
                        backgroundImage: NetworkImage(player.photoUrl),
                      ),
                      title: Text(player.name),
                      trailing: Text('Position: ${player.position}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
