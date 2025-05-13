import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/common_service.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';
import 'package:maydon_go/src/common/service/shared_preference_service.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../common/constants/config.dart';
import '../../../common/model/chat_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatSState> {
  final String serverUrl = Config.wsServerUrl;
  late types.User currentUser;
  final Logger _logger = Logger();
  final Set<String> _messageIds = {};
  late final StompClient _stompClient;
  int? _activeChatId;
  StompUnsubscribe? _unsubscribeCallback;
  final apiService = CommonService(ApiClient().dio);
  bool _isConnected = false;

  ChatCubit() : super(ChatSState(messages: [], status: ChatStatus.initial)) {
    _initStomp();
  }

  void _initStomp() async {
    final wallpaper = await ShPService.getWallpaper();
    emit(ChatSState(messages: [], wallpaper: wallpaper));
    final user = await UserService(ApiClient().dio).getUser();
    currentUser = types.User(
      id: user.id.toString(),
      imageUrl: user.imageUrl,
      firstName: user.fullName,
    );
    _stompClient = StompClient(
      config: StompConfig(
        url: serverUrl,
        onConnect: _onConnect,
        onWebSocketError: (error) {
          _logger.e("WebSocket error: $error");
          _isConnected = false;
        },
        onStompError: (frame) {
          _logger.e("STOMP protocol error: ${frame.body}");
          _isConnected = false;
        },
        onDisconnect: (_) {
          _logger.w("STOMP disconnected");
          _isConnected = false;
        },
        beforeConnect: () async {
          _logger.i("Connecting to STOMP...");
          await Future.delayed(const Duration(milliseconds: 200));
        },
        reconnectDelay: const Duration(seconds: 5),
        connectionTimeout: const Duration(seconds: 10),
      ),
    );
    _stompClient.activate();
  }

  void changeWallpaper(String path) async {
    await ShPService.setWallpaper(path);
    final wallpaper = await ShPService.getWallpaper();

    emit(state.copyWith(wallpaper: wallpaper));
  }

  void _onConnect(StompFrame frame) async {
    _logger.i("Connected to STOMP");
    _isConnected = true;

    if (_activeChatId != null) {
      await _subscribeToChat(_activeChatId!);
    }
  }

  Future<void> joinChat(int chatId) async {
    if (_activeChatId == chatId && _isConnected) return;

    _unsubscribePrevious();
    _activeChatId = chatId;

    await _loadMessages(chatId);

    if (_isConnected) {
      await _subscribeToChat(chatId);
    }
  }

  void _unsubscribePrevious() {
    _unsubscribeCallback?.call();
    _unsubscribeCallback = null;
  }

  Future<void> _subscribeToChat(int chatId) async {
    final destination = '/topic/chat.$chatId';

    _unsubscribeCallback = _stompClient.subscribe(
      destination: destination,
      headers: {'id': 'chat-$chatId'},
      callback: (frame) {
        if (frame.body != null) {
          try {
            final data = jsonDecode(frame.body!);

            if (data['senderId'].toString() == currentUser.id) return;

            final message = types.TextMessage(
              id: data['id'].toString(),
              text: data['content'] ?? '',
              createdAt:
                  data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
              author: types.User(
                id: data['senderId'].toString(),
                firstName: data['senderName'] ?? 'Unknown',
              ),
            );

            _addMessageToState(message);
          } catch (e) {
            _logger.e("Error parsing STOMP message: $e");
          }
        }
      },
    );

    _logger.i("Subscribed to $destination");
  }

  Future<void> _loadMessages(int chatId) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      final chatModel = await apiService.getChatFromApi(chatId);

      final messages = chatModel.messages
          .map((msg) {
            final sender = chatModel.members.firstWhere(
              (m) => m.userId == msg.senderId,
              orElse: () => ChatMember(
                id: msg.id,
                userId: msg.senderId,
                role: 'unknown',
                joinedAt: DateTime.now(),
              ),
            );

            return types.TextMessage(
              id: msg.id.toString(),
              text: msg.content,
              createdAt: msg.sentAt.millisecondsSinceEpoch,
              author: types.User(
                id: sender.userId.toString(),
                firstName: sender.role,
              ),
            );
          })
          .toList()
          .reversed
          .toList();

      emit(state.copyWith(messages: messages, status: ChatStatus.loaded));
    } catch (e) {
      _logger.e("Failed to load messages: $e");
      emit(
          state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  void _addMessageToState(types.TextMessage message) {
    if (_messageIds.contains(message.id)) return;

    _messageIds.add(message.id);
    final newMessages = [message, ...state.messages];
    emit(state.copyWith(messages: newMessages));
  }

  void sendMessage(String text) {
    if (!_isConnected || _activeChatId == null) {
      _logger.w("Not connected or no active chat");
      return;
    }

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final message = types.TextMessage(
      id: messageId,
      text: text,
      createdAt: timestamp,
      author: currentUser,
    );

    emit(state.copyWith(messages: [message, ...state.messages]));

    final data = {
      'id': messageId,
      'senderId': currentUser.id,
      'senderName': currentUser.firstName,
      'content': text,
      'createdAt': timestamp,
    };

    try {
      _stompClient.send(
        destination: '/app/chat.send/$_activeChatId',
        body: jsonEncode(data),
      );
    } catch (e) {
      _logger.e("Failed to send message: $e");

// Revert optimistic update
      final filtered = state.messages.where((m) => m.id != messageId).toList();
      emit(state.copyWith(messages: filtered));
    }
  }

  @override
  Future<void> close() async {
    _logger.i("Closing ChatCubit and STOMP connection");
    _unsubscribePrevious();
    _stompClient.deactivate();
    return super.close();
  }
}
