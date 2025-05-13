part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatSState {
  final List<types.Message> messages;
  final String? wallpaper;

  final ChatStatus status;
  final String? errorMessage;

  ChatSState({
    this.wallpaper,
    required this.messages,
    this.status = ChatStatus.initial,
    this.errorMessage,
  });

  ChatSState copyWith({
    List<types.Message>? messages,
    ChatStatus? status,
    final String? wallpaper,
    String? errorMessage,
  }) {
    return ChatSState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      wallpaper: wallpaper ?? this.wallpaper,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
