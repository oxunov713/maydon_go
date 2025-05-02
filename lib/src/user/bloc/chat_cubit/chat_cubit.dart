import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../common/model/chat_model.dart';
import '../../../common/service/api_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatSState> {
  final String serverUrl;
  final types.User currentUser;
  late final StompClient _stompClient;

  final Logger _logger = Logger();
  late int _activeChatId;

  ChatCubit({
    required this.serverUrl,
    required this.currentUser,
  }) : super(const ChatSState(messages: [])) {
    _connect();
  }

  void _connect() {
    _stompClient = StompClient(
      config: StompConfig(
        url: serverUrl,
        // e.g., ws://localhost:8080/ws
        onConnect: _onConnect,
        beforeConnect: () async {
          _logger.d("Connecting to STOMP...");
          await Future.delayed(const Duration(milliseconds: 200));
        },
        onWebSocketError: (error) {
          _logger.e("WebSocket error: $error");
        },
        onStompError: (frame) {
          _logger.e("STOMP error: ${frame.body}");
        },
        onDisconnect: (frame) {
          _logger.d("Disconnected from STOMP");
        },
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    _logger.d("Connected to STOMP");
    joinChat(_activeChatId);
  }

  /// ✅ Chatga ulanadi va kelayotgan xabarlarni tinglaydi
  void joinChat(int chatId) async {
    _activeChatId = chatId;
    final destination = '/topic/chat.$chatId';
    await loadMessagesFromApi(chatId);
    _logger.d("Subscribing to $destination");

    _stompClient.subscribe(
      destination: destination,
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          _logger.d("Received: $data");

          final message = types.TextMessage(
            id: data['id'] ?? DateTime.now().toString(),
            text: data['content'],
            createdAt:
                data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
            author: types.User(
              id: data['senderId'].toString(),
              firstName: data['senderName'] ?? 'Unknown',
            ),
          );

          void sendMessage(String text) {
            final message = types.TextMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: text,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              author: currentUser,
            );

            final data = {
              'senderId': currentUser.id,
              'content': message.text,
            };

            _stompClient.send(
              destination: '/app/chat.send/$_activeChatId',
              body: jsonEncode(data),
            );

            // Create a new list instance when emitting the state
            emit(ChatSState(messages: [message] + List.from(state.messages)));
          }
        }
      },
    );
  }

  /// ✅ Xabar yuborish
  void sendMessage(String text) {
    final message = types.TextMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      author: currentUser,
    );

    final data = {
      'senderId': currentUser.id,
      'content': message.text,
    };

    _stompClient.send(
      destination: '/app/chat.send/$_activeChatId',
      body: jsonEncode(data),
    );

    emit(ChatSState(messages: [message] + List.from(state.messages)));
  }

  Future<void> loadMessagesFromApi(int chatId) async {
    try {
      final chatModel = await ApiService().getChatFromApi(chatId);

      // API'dan kelgan ChatMessage'larni TextMessage'ga aylantiramiz
      final messages = chatModel.messages
          .map((chatMessage) {
            return types.TextMessage(
              id: chatMessage.id.toString(),
              text: chatMessage.content,
              createdAt: chatMessage.sentAt.millisecondsSinceEpoch,
              author: types.User(
                id: chatMessage.senderId.toString(),
                firstName: chatModel.members
                    .firstWhere(
                      (member) => member.userId == chatMessage.senderId,
                      orElse: () => ChatMember(
                        id: chatMessage.id,
                        userId: chatMessage.senderId,
                        role: 'unknown',
                        joinedAt: DateTime.now(),
                      ),
                    )
                    .role, // yoki ismingiz bo'lsa o'shani qo'yish mumkin
              ),
            );
          })
          .toList()
          .reversed
          .toList(); // eski xabarlar pastda bo'lishi uchun reversed

      emit(ChatSState(messages: messages));
    } catch (e) {
      _logger.e("Xatolik yuz berdi: $e");
    }
  }

  @override
  Future<void> close() {
    _logger.d("Closing STOMP connection");
    _stompClient.deactivate();
    return super.close();
  }
}
