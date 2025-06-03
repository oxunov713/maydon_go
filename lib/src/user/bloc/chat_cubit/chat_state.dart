part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatSState {
  final List<ChatMessage> messages;
  final List<ChatMessage>? pinnedMessages;
  final String? wallpaper;

  final ChatStatus status;
  final String? errorMessage;

  ChatSState({
    this.wallpaper,
    required this.messages,
    this.pinnedMessages,
    this.status = ChatStatus.initial,
    this.errorMessage,
  });

  ChatSState copyWith({
    List<ChatMessage>? messages,
    List<ChatMessage>? pinnedMessages,
    ChatStatus? status,
    final String? wallpaper,
    String? errorMessage,
  }) {
    return ChatSState(
      messages: messages ?? this.messages,
      pinnedMessages: pinnedMessages ?? this.pinnedMessages,
      status: status ?? this.status,
      wallpaper: wallpaper ?? this.wallpaper,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
