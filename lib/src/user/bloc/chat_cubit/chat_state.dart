import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatSState extends Equatable {
  final List<types.Message> messages;

  const ChatSState({required this.messages});

  ChatSState copyWith({
    List<types.Message>? messages,
  }) {
    return ChatSState(
      messages: messages ?? this.messages,
    );
  }

  @override
  List<Object> get props => [messages];
}
