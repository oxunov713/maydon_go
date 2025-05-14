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

part 'team_chat_state.dart';

class TeamChatCubit extends Cubit<TeamChatState> {
  final String serverUrl = Config.wsServerUrl;
  late types.User currentUser;
  final Logger _logger = Logger();
  final Set<String> _messageIds = {};
  late final StompClient _stompClient;
  int? _activeGroupId;
  StompUnsubscribe? _unsubscribeCallback;
  final apiService = CommonService(ApiClient().dio);
  bool _isConnected = false;
  final StreamController<List<types.Message>> _messagesStreamController =
  StreamController.broadcast();

  TeamChatCubit() : super(TeamChatState(messages: [], status: TeamChatStatus.initial)) {
    _initStomp();
  }

  void _initStomp() async {

    final user = await UserService(ApiClient().dio).getUser();
    currentUser = types.User(
      id: user.id.toString(),
      imageUrl: user.imageUrl,
      firstName: user.fullName,
    );
    emit(TeamChatState(
        messages: [],

        status: TeamChatStatus.loaded,
        currentUser: currentUser));

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



  void _onConnect(StompFrame frame) async {
    _logger.i("Connected to STOMP");
    _isConnected = true;

    if (_activeGroupId != null) {
      await _subscribeToGroupChat(_activeGroupId!);
    } else {
      _logger.w("No active group to subscribe to");
    }
  }

  void _onWebSocketError(dynamic error) {
    _logger.e("WebSocket error: $error");
    _isConnected = false;
    emit(state.copyWith(status: TeamChatStatus.error, errorMessage: "WebSocket error"));
  }

  void _onStompError(StompFrame frame) {
    _logger.e("STOMP protocol error: ${frame.body}");
    _isConnected = false;
    emit(state.copyWith(status: TeamChatStatus.error, errorMessage: "STOMP error"));
  }



  Future<void> joinGroupChat(int groupId) async {
    // Agar guruh allaqachon faol bo'lsa, u holda boshqa guruhga o'tishning hojati yo'q
    if (_activeGroupId == groupId && _isConnected) return;

    // Avvalgi guruhdan obuna bo'lishni bekor qilamiz
    _unsubscribePrevious();

    // Yangi guruhni faollashtiramiz
    _activeGroupId = groupId;

    // Yangi guruh xabarlarini yuklaymiz
    await _loadGroupMessages(groupId);

    // Agar STOMP ulanishi mavjud bo'lsa, guruhga obuna bo'lamiz
    if (_isConnected) {
      await _subscribeToGroupChat(groupId);
    } else {
      // Agar STOMP ulanishi yo'q bo'lsa, qayta ulanishga harakat qilamiz
      _logger.w("WebSocket not connected, attempting reconnect...");
      _stompClient.activate();
    }
  }



  void _unsubscribePrevious() {
    if (_unsubscribeCallback != null) {
      _logger.i("Unsubscribing from previous chat");
      _unsubscribeCallback!();
      _unsubscribeCallback = null;
    }
  }


  Future<void> _subscribeToGroupChat(int groupId) async {
    final destination = '/topic/chat.$groupId';

    _unsubscribeCallback = _stompClient.subscribe(
      destination: destination,
      headers: {'id': 'groupchat-$groupId', 'persistent': 'true'},
      callback: (frame) {
        if (frame.body != null) {
          try {
            final data = jsonDecode(frame.body!);
            _logger.d("Received message: $data");

            if (data['senderId'].toString() == currentUser.id) return;

            final message = types.TextMessage(
              id: data['id'].toString(),
              text: data['content'] ?? '',
              createdAt: data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
              author: types.User(
                id: data['senderId'].toString(),
                firstName: data['senderName'] ?? 'Unknown',
                imageUrl: data['senderAvatarUrl'],
              ),
            );

            _addMessageToState(message);
            _messagesStreamController.add([...state.messages, message]);
          } catch (e) {
            _logger.e("Error parsing STOMP message: $e");
          }
        }
      },
    );

    _logger.i("Subscribed to group chat $destination");
  }

  Future<void> _loadGroupMessages(int groupId) async {
    emit(state.copyWith(status: TeamChatStatus.loading));
    try {
      final groupChatModel = await apiService.getChatFromApi(groupId);

      final messages = groupChatModel.messages
          .map((msg) {
        final sender = groupChatModel.members.firstWhere(
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
          ),
        );
      })
          .toList()
          .reversed
          .toList();

      // Xabarlarni yangilash
      emit(state.copyWith(
        messages: messages,
        status: TeamChatStatus.loaded,
        groupName: groupChatModel.name,
        members: groupChatModel.members.map((member) => types.User(
          id: member.userId.toString(),
        )).toList(),
      ));
    } catch (e) {
      _logger.e("Failed to load group messages: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error,
          errorMessage: e.toString()
      ));
    }
  }


  void _addMessageToState(types.TextMessage message) {
    if (_messageIds.contains(message.id)) return;

    _messageIds.add(message.id);
    final newMessages = [message, ...state.messages];
    emit(state.copyWith(messages: newMessages));
  }

  void sendMessage(String text) {
    if (!_isConnected || _activeGroupId == null) {
      _logger.w("Not connected or no active group chat");
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
      'senderAvatarUrl': currentUser.imageUrl,
      'content': text,
      'createdAt': timestamp,
      'groupId': _activeGroupId,
      'persistent': true,
    };

    try {
      _stompClient.send(
        destination: '/app/chat.send/$_activeGroupId',
        headers: {'persistent': 'true'},
        body: jsonEncode(data),
      );
      _logger.i("Message sent to server: $data");
    } catch (e) {
      _logger.e("Failed to send group message: $e");
      final filtered = state.messages.where((m) => m.id != messageId).toList();
      emit(state.copyWith(messages: filtered));
    }
  }


  @override
  Future<void> close() async {
    _logger.i("Closing TeamChatCubit and cleaning up");
    await _messagesStreamController.close();
    _unsubscribePrevious();
    _stompClient.deactivate();
    return super.close();
  }
}