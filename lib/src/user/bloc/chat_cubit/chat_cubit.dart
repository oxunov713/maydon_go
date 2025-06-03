import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
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
  late ChatMember currentUser;
  final Logger _logger = Logger();
  final Set<String> _processedMessageIds = {};
  late final StompClient _stompClient;
  int? _activeChatId;
  StompUnsubscribe? _unsubscribeCallback;
  final CommonService _apiService;
  bool _isConnected = false;
  Timer? _reconnectTimer;

  ChatCubit()
      : _apiService = CommonService(ApiClient().dio),
        super(ChatSState(status: ChatStatus.initial, messages: [])) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Load wallpaper preference
      final wallpaper = await ShPService.getWallpaper();
      emit(state.copyWith(wallpaper: wallpaper));

      // Load current user data
      final user = await UserService(ApiClient().dio).getUser();
      currentUser = ChatMember(
        id: user.id!,
        userId: user.id!,
        role: user.role,
        userFullName: user.fullName,
        joinedAt: DateTime.now(),
      );

      _setupStompClient();
    } catch (e) {
      _logger.e("Initialization error: $e");
      emit(state.copyWith(
          status: ChatStatus.error, errorMessage: "Failed to initialize chat"));
    }
  }

  void _setupStompClient() {
    _stompClient = StompClient(
      config: StompConfig(
        url: serverUrl,
        onConnect: _onConnect,
        onWebSocketError: (error) =>
            _handleConnectionError("WebSocket error: $error"),
        onStompError: (frame) =>
            _handleConnectionError("STOMP error: ${frame.body}"),
        onDisconnect: (_) => _handleDisconnection(),
        beforeConnect: () async {
          _logger.i("Connecting to STOMP...");
          await Future.delayed(const Duration(milliseconds: 200));
        },
        reconnectDelay: const Duration(seconds: 5),
        connectionTimeout: const Duration(seconds: 10),
        stompConnectHeaders: {'userId': currentUser.id.toString()},
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    _logger.i("Connected to STOMP server");
    _isConnected = true;
    _reconnectTimer?.cancel();

    if (_activeChatId != null) {
      _subscribeToChat(_activeChatId!);
    }
  }

  void _handleConnectionError(String error) {
    _logger.e(error);
    _isConnected = false;
    _scheduleReconnect();
  }

  void _handleDisconnection() {
    _logger.w("Disconnected from STOMP server");
    _isConnected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 10), () {
      if (!_isConnected) {
        _logger.i("Attempting to reconnect...");
        _stompClient.deactivate();
        _stompClient.activate();
      }
    });
  }

  Future<void> joinChat(int chatId) async {
    if (_activeChatId == chatId && _isConnected) return;

    _unsubscribePrevious();
    _activeChatId = chatId;

    try {
      await _loadMessages(chatId);
      if (_isConnected) {
        _subscribeToChat(chatId);
      }
    } catch (e) {
      _logger.e("Failed to join chat: $e");
      emit(state.copyWith(
          status: ChatStatus.error, errorMessage: "Failed to join chat"));
    }
  }

  void _unsubscribePrevious() {
    _unsubscribeCallback?.call();
    _unsubscribeCallback = null;
    _processedMessageIds.clear();
  }

  void _subscribeToChat(int chatId) {
    final destination = '/topic/chat.$chatId';

    _unsubscribeCallback = _stompClient.subscribe(
      destination: destination,
      headers: {'id': 'chat-$chatId'},
      callback: (frame) {
        if (frame.body == null) return;

        try {
          final data = jsonDecode(frame.body!);
          final messageId = data['id'].toString();

          // Skip if message already processed or is from current user
          if (_processedMessageIds.contains(messageId)) return;
          if (data['senderId'].toString() == currentUser.id.toString()) return;

          _processedMessageIds.add(messageId);

          final message = ChatMessage(
            id: int.parse(messageId),
            senderId: int.parse(data['senderId'].toString()),
            type: 'text',
            content: data['content'] ?? '',
            sentAt: DateTime.fromMillisecondsSinceEpoch(
              data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
            ),
          );

          _addMessageToState(message);
        } catch (e) {
          _logger.e("Error processing message: $e");
        }
      },
    );

    _logger.i("Subscribed to $destination");
  }

  Future<void> _loadMessages(int chatId) async {
    emit(state.copyWith(status: ChatStatus.loading));

    try {
      final chatModel = await _apiService.getChatFromApi(chatId);

      // Process pinned messages
      final pinnedMessages = chatModel.pinnedMessages;

      emit(state.copyWith(
        status: ChatStatus.loaded,
        messages: chatModel.messages!.reversed.toList(),
        pinnedMessages: pinnedMessages,
      ));
    } catch (e) {
      _logger.e("Failed to load messages: $e");
      emit(state.copyWith(
          status: ChatStatus.error, errorMessage: "Failed to load messages"));
      rethrow;
    }
  }

  void _addMessageToState(ChatMessage message) {
    final updatedMessages = [
      message,
      ...state.messages,
    ];

    emit(state.copyWith(messages: updatedMessages));
  }

  Future<void> sendMessage(String text) async {
    if (!_isConnected || _activeChatId == null) {
      _logger.w("Cannot send message - not connected or no active chat");
      return;
    }

    if (text.trim().isEmpty) return;

    final messageId = DateTime.now().millisecondsSinceEpoch;
    final timestamp = DateTime.now();

    // Create optimistic message
    final optimisticMessage = ChatMessage(
      id: messageId,
      senderId: currentUser.id,
      type: 'text',
      content: text,
      sentAt: timestamp,
    );

    // Update state immediately
    _addMessageToState(optimisticMessage);

    try {
      // Prepare message data
      final data = {
        'id': messageId.toString(),
        'senderId': currentUser.id.toString(),
        'senderName': currentUser.userFullName,
        'content': text,
        'createdAt': timestamp.millisecondsSinceEpoch,
      };

      // Send via STOMP
      _stompClient.send(
        destination: '/app/chat.send/$_activeChatId',
        body: jsonEncode(data),
        headers: {'userId': currentUser.id.toString()},
      );

      _logger.i("Message sent successfully");
    } catch (e) {
      _logger.e("Failed to send message: $e");

      // Remove optimistic message on failure
      final filteredMessages =
          state.messages.where((msg) => msg.id != messageId).toList();
      emit(state.copyWith(messages: filteredMessages));
    }
  }

  Future<void> deleteMessage(int messageId) async {
    if (_activeChatId == null) return;

    try {
      // Optimistic update
      final updatedMessages =
          state.messages.where((msg) => msg.id != messageId).toList();
      emit(state.copyWith(messages: updatedMessages));

      // API call
      await _apiService.deleteMessage(
        chatId: _activeChatId!,
        messageId: messageId,
      );

      _logger.i("Message deleted successfully");
    } catch (e) {
      _logger.e("Failed to delete message: $e");
      // Reload messages to revert state
      await _loadMessages(_activeChatId!);
    }
  }

  Future<void> deleteChat() async {
    if (_activeChatId == null) return;

    try {
      await _apiService.deleteChat(chatId: _activeChatId ?? -1);
      emit(state.copyWith(
        status: ChatStatus.initial,
        messages: [],
        pinnedMessages: [],
      ));
      _activeChatId = null;
      _unsubscribePrevious();
    } catch (e) {
      _logger.e("Failed to delete chat: $e");
      emit(state.copyWith(
          status: ChatStatus.error, errorMessage: "Failed to delete chat"));
    }
  }

  Future<void> pinMessage(int messageId) async {
    if (_activeChatId == null) return;

    try {
      await _apiService.pinMessage(
        chatId: _activeChatId!,
        messageId: messageId,
      );

      // Reload chat to get updated pinned messages
      await _loadMessages(_activeChatId!);
    } catch (e) {
      _logger.e("Failed to pin message: $e");
      emit(state.copyWith(
          status: ChatStatus.error, errorMessage: "Failed to pin message"));
    }
  }

  Future<void> unpinMessage(int messageId) async {
    if (_activeChatId == null) return;
    try {
      await _apiService.unpinMessage(
        chatId: _activeChatId ?? -1,
        messageId: messageId,
      );

      await _loadMessages(_activeChatId!);
    } catch (e) {
      _logger.e("Failed to unpin message: $e");
      emit(state.copyWith(
          status: ChatStatus.error, errorMessage: "Failed to unpin message"));
    }
  }

  Future<void> changeWallpaper(String path) async {
    try {
      await ShPService.setWallpaper(path);
      final wallpaper = await ShPService.getWallpaper();
      emit(state.copyWith(wallpaper: wallpaper));
    } catch (e) {
      _logger.e("Failed to change wallpaper: $e");
    }
  }

  @override
  Future<void> close() async {
    _logger.i("Disposing ChatCubit");

    _unsubscribePrevious();
    _reconnectTimer?.cancel();

    if (_stompClient.connected) {
      _stompClient.deactivate();
    }

    return super.close();
  }
}
