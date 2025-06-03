part of 'team_chat_cubit.dart';

enum TeamChatStatus { initial, loading, loaded, error, disconnected }

class TeamChatState {
  final TeamChatStatus status;
  final String? errorMessage;
  final String? groupName;
  final List<MemberModel> members;
  final List<ChatMessage> messages;
  final List<ChatMessage> pinnedMessages;
  final UserModel? currentUser;
  final DateTime? lastUpdate;
  final int activePinnedIndex;
  final bool isPinnedExpanded;
  final ChatModel? chatModel;

  const TeamChatState(
      {required this.status,
      this.errorMessage,
      this.groupName,
      this.members = const [],
      this.messages = const [],
      this.pinnedMessages = const [],
      this.currentUser,
      this.lastUpdate,
      this.activePinnedIndex = 0,
      this.isPinnedExpanded = false,
      required this.chatModel});

  TeamChatState copyWith({
    TeamChatStatus? status,
    String? errorMessage,
    String? groupName,
    List<MemberModel>? members,
    List<ChatMessage>? messages,
    List<ChatMessage>? pinnedMessages,
    UserModel? currentUser,
    DateTime? lastUpdate,
    int? activePinnedIndex,
    bool? isPinnedExpanded,
    ChatModel? chatModel,
  }) {
    return TeamChatState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      groupName: groupName ?? this.groupName,
      members: members ?? this.members,
      messages: messages ?? this.messages,
      pinnedMessages: pinnedMessages ?? this.pinnedMessages,
      currentUser: currentUser ?? this.currentUser,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      activePinnedIndex: activePinnedIndex ?? this.activePinnedIndex,
      isPinnedExpanded: isPinnedExpanded ?? this.isPinnedExpanded,
      chatModel: chatModel ?? this.chatModel,
    );
  }
}
