part of 'team_chat_cubit.dart';

enum TeamChatStatus { initial, loading, loaded, error, disconnected }

class TeamChatState {
  final TeamChatStatus status;
  final String? errorMessage;
  final String? groupName;
  final List<types.User> members;
  final List<types.Message> messages;
  final types.User? currentUser;
  final DateTime? lastUpdate;

  const TeamChatState({
    required this.status,
    this.errorMessage,
    this.groupName,
    this.members = const [],
    this.messages = const [],
    this.currentUser,
    this.lastUpdate,
  });

  factory TeamChatState.initial() => const TeamChatState(status: TeamChatStatus.initial);

  TeamChatState copyWith({
    TeamChatStatus? status,
    String? errorMessage,
    String? groupName,
    List<types.User>? members,
    List<types.Message>? messages,
    types.User? currentUser,
    DateTime? lastUpdate,
  }) {
    return TeamChatState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      messages: messages ?? this.messages,
      currentUser: currentUser ?? this.currentUser,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}