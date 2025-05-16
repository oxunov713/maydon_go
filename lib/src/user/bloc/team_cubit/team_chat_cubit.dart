import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/common_service.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';
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

  TeamChatCubit()
      : super(TeamChatState(messages: [], status: TeamChatStatus.initial)) {
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
        messages: [], status: TeamChatStatus.loaded, currentUser: currentUser));

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

  Future<void> joinGroupChat(int groupId) async {
    if (_activeGroupId == groupId && _isConnected) return;

    _unsubscribePrevious();
    _activeGroupId = groupId;
    resetState();
    try {
      // Guruh ma'lumotlarini yuklash
      final groupChatModel = await apiService.getChatFromApi(groupId);

      // Memberlarni types.User formatiga o'tkazib state ga saqlash
      final members = groupChatModel.members
          .map((member) => types.User(
                id: member.userId.toString(),
                firstName: member.userFullName ?? 'User ${member.userId}',
                imageUrl: member.userImage,
              ))
          .toList();

      // Xabarlarni yukash va member ma'lumotlarini ulash
      final messages = groupChatModel.messages
          .map((msg) {
            final sender = members.firstWhere(
              (m) => m.id == msg.senderId.toString(),
              orElse: () => types.User(
                id: msg.senderId.toString(),
                firstName: 'User ${msg.senderId}',
              ),
            );

            return types.TextMessage(
              id: msg.id.toString(),
              text: msg.content,
              createdAt: msg.sentAt.millisecondsSinceEpoch,
              author: sender,
            );
          })
          .toList()
          .reversed
          .toList();
      final pinnedMessages = groupChatModel.pinnedMessages.map((msg) {
        final sender = members.firstWhere(
              (m) => m.id == msg.senderId.toString(),
          orElse: () => types.User(
            id: msg.senderId.toString(),
            firstName: 'User ${msg.senderId}',
          ),
        );

        return types.TextMessage(
          id: msg.id.toString(),
          text: msg.content,
          createdAt: msg.sentAt.millisecondsSinceEpoch,
          author: sender,
        );
      }).toList();
      emit(state.copyWith(
        messages: messages,
        members: members,
        pinnedMessages: pinnedMessages,
        groupName: groupChatModel.name,
        status: TeamChatStatus.loaded,
      ));

      if (_isConnected) {
        await _subscribeToGroupChat(groupId);
      } else {
        _stompClient.activate();
      }
    } catch (e) {
      _logger.e("Failed to join group chat: $e");
      emit(state.copyWith(
        status: TeamChatStatus.error,
        errorMessage: "Failed to load chat data",
      ));
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
            if (data['senderId'].toString() == currentUser.id) return;

            // State.dagi memberlardan yuboruvchini topish
            final sender = state.members.firstWhere(
              (m) => m.id == data['senderId'].toString(),
              orElse: () => types.User(
                id: data['senderId'].toString(),
                firstName: data['senderName'] ?? 'User ${data['senderId']}',
                imageUrl: data['senderAvatarUrl'],
              ),
            );

            final message = types.TextMessage(
              id: data['id'].toString(),
              text: data['content'] ?? '',
              createdAt:
                  data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
              author: sender,
            );

            _addMessageToState(message);
          } catch (e) {
            _logger.e("Error processing message: $e");
          }
        }
      },
    );
  }

  Future<void> _loadGroupMessages(int groupId) async {
    emit(state.copyWith(status: TeamChatStatus.loading));
    try {
      final groupChatModel = await apiService.getChatFromApi(groupId);

      final messages = groupChatModel.messages.map((msg) {
        // Find the member who sent this message
        final sender = groupChatModel.members.firstWhere(
          (member) => member.userId == msg.senderId,
          orElse: () => ChatMember(
            id: -1,
            userId: msg.senderId,
            role: 'unknown',
            joinedAt: DateTime.now(),
            userFullName: 'Unknown',
            // Add default name
            userPhoneNumber: '', // Add default phone
          ),
        );

        return types.TextMessage(
          id: msg.id.toString(),
          text: msg.content,
          createdAt: msg.sentAt.millisecondsSinceEpoch,
          author: types.User(
            id: sender.userId.toString(),
            firstName: sender.userFullName ?? 'Unknown',
            imageUrl: sender.userImage,
          ),
        );
      }).toList();

      // Reverse to show newest messages last (or first, depending on your UI)
      final reversedMessages = messages.reversed.toList();

      emit(state.copyWith(
        messages: reversedMessages,
        status: TeamChatStatus.loaded,
        groupName: groupChatModel.name,
        members: groupChatModel.members
            .map((member) => types.User(
                  id: member.userId.toString(),
                  firstName: member.userFullName,
                  imageUrl: member.userImage,
                ))
            .toList(),
      ));
    } catch (e) {
      _logger.e("Failed to load group messages: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error, errorMessage: e.toString()));
    }
  }
  Future<void> pinMessageToChat(int messageId) async {
    final chatId = _activeGroupId;
    if (chatId == null) return;

    try {
      _logger.i("📌 Pinning message $messageId in chat $chatId");
      await apiService.pinMessage(chatId: chatId, messageId: messageId);

      // ⚠️ Backend pinlangan xabarni darhol qaytarmasa, uni yangilaymiz
      final updatedChat = await apiService.getChatFromApi(chatId);
      final members = updatedChat.members.map((m) => types.User(
        id: m.userId.toString(),
        firstName: m.userFullName ?? 'Unknown',
        imageUrl: m.userImage,
      )).toList();

      final pinnedMessages = updatedChat.pinnedMessages.map((msg) {
        final sender = members.firstWhere(
              (u) => u.id == msg.senderId.toString(),
          orElse: () => types.User(id: msg.senderId.toString()),
        );

        return types.TextMessage(
          id: msg.id.toString(),
          text: msg.content,
          createdAt: msg.sentAt.millisecondsSinceEpoch,
          author: sender,
        );
      }).toList();

      _logger.i("✅ ${pinnedMessages.length} xabar pinlangan");

      emit(state.copyWith(pinnedMessages: pinnedMessages));
    } catch (e) {
      _logger.e("❌ Pin message failed: $e");
    }
  }
  Future<void> deleteMessageFromChat(int messageId) async {
    final chatId = _activeGroupId;
    if (chatId == null) return;

    try {
      _logger.i("🗑️ Deleting message $messageId in chat $chatId");
      await apiService.deleteMessage(chatId: chatId, messageId: messageId);

      // Local holatda xabarni olib tashlaymiz
      final updatedMessages = state.messages
          .where((msg) => msg.id != messageId.toString())
          .toList();

      emit(state.copyWith(messages: updatedMessages));
    } catch (e) {
      _logger.e("❌ Failed to delete message: $e");
    }
  }


  void _addMessageToState(types.Message message) {
    if (_messageIds.contains(message.id)) return;

    // Agar author ma'lumotlari yetarli bo'lmasa, state.dagi memberlardan to'ldirish
    if (message.author.firstName == null || message.author.imageUrl == null) {
      final existingMember = state.members.firstWhere(
        (m) => m.id == message.author.id,
        orElse: () => message.author,
      );
      message = message.copyWith(author: existingMember);
    }

    _messageIds.add(message.id);
    final newMessages = [message, ...state.messages];
    emit(state.copyWith(messages: newMessages));
  }

  void sendMessage(String text) {
    if (!_isConnected || _activeGroupId == null) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final data = {
      'id': messageId,
      'senderId': currentUser.id,
      'content': text,
      'createdAt': timestamp,
      'groupId': _activeGroupId,
    };

    // Optimistik ravishda xabarni state ga qo'shamiz
    final message = types.TextMessage(
      id: messageId,
      text: text,
      createdAt: timestamp,
      author: currentUser,
    );

    _addMessageToState(message);

    _stompClient.send(
      destination: '/app/chat.send/$_activeGroupId',
      body: jsonEncode(data),
    );
  }

  void resetState() {
    emit(TeamChatState(
      messages: [],
      status: TeamChatStatus.initial,
      members: [],
      pinnedMessages: [],
      groupName: null,
      currentUser: currentUser,
    ));
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
