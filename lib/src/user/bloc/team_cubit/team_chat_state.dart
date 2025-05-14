part of 'team_chat_cubit.dart';

enum TeamChatStatus { initial, loading, loaded, error }

class TeamChatState {
  final List<types.Message> messages;
  final TeamChatStatus status;
  final String? errorMessage;
  types.User? currentUser;
  final String? wallpaper;
  final String? groupName;
  final String? groupAvatar;
  final List<types.User> members;

  TeamChatState({
    required this.messages,
    required this.status,
    this.currentUser,
    this.errorMessage,
    this.wallpaper,
    this.groupName,
    this.groupAvatar,
    this.members = const [],
  });

  TeamChatState copyWith({
    List<types.Message>? messages,
    TeamChatStatus? status,
    String? errorMessage,
    types.User? currentUser,
    String? wallpaper,
    String? groupName,
    String? groupAvatar,
    List<types.User>? members,
  }) {
    return TeamChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      errorMessage: errorMessage ?? this.errorMessage,
      wallpaper: wallpaper ?? this.wallpaper,
      groupName: groupName ?? this.groupName,
      groupAvatar: groupAvatar ?? this.groupAvatar,
      members: members ?? this.members,
    );
  }
}
