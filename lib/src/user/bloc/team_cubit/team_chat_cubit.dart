import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/model/team_model.dart'; // Assuming MemberModel is in team_model.dart
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/common_service.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../common/constants/config.dart';
import '../../../common/model/chat_model.dart'; // Assuming ChatMessage is in chat_model.dart

part 'team_chat_state.dart';

class TeamChatCubit extends Cubit<TeamChatState> {
  final String serverUrl = Config.wsServerUrl;
  late ChatMember currentUser; // ChatCubit'dan olingan
  final Logger _logger = Logger();
  final Set<String> _processedMessageIds =
      {}; // Qayta ishlov berilgan xabarlar IDsi
  late final StompClient _stompClient;
  int? _activeGroupId;
  StompUnsubscribe? _unsubscribeCallback;
  final CommonService _apiService; // _apiService deb nomlandi
  bool _isConnected = false;
  Timer? _reconnectTimer; // Qayta ulanish taymeri

  TeamChatCubit()
      : _apiService = CommonService(ApiClient().dio),
        super(TeamChatState(
            messages: [],
            status: TeamChatStatus.initial,
            members: [],
            pinnedMessages: [],
            groupName: '',
            activePinnedIndex: 0,
            isPinnedExpanded: false,
            currentUser: null,
            chatModel: null)) {
    _initialize(); // _initStomp o'rniga _initialize ishlatildi
  }

  Future<void> _initialize() async {
    try {
      // Joriy foydalanuvchi ma'lumotlarini yuklash
      final user = await UserService(ApiClient().dio).getUser();
      currentUser = ChatMember(
        id: user.id!,
        userId: user.id!,
        role: user.role,
        userFullName: user.fullName,
        joinedAt: DateTime.now(),
      );

      // Holatni yangilash
      emit(state.copyWith(
        currentUser: user, // `User` ob'ektini `currentUser`ga o'rnatish
        status:
            TeamChatStatus.loaded, // Dastlabki holatni `loaded` qilib o'rnatish
      ));

      _setupStompClient(); // Stomp mijozini sozlash
    } catch (e) {
      _logger.e("Initialization error: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error,
          errorMessage: "Failed to initialize chat"));
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
        stompConnectHeaders: {
          'userId': currentUser.id.toString()
        }, // `ChatCubit` dagi kabi
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    _logger.i("Connected to STOMP server");
    _isConnected = true;
    _reconnectTimer?.cancel(); // Qayta ulanish taymerini bekor qilish

    if (_activeGroupId != null) {
      _subscribeToGroupChat(
          _activeGroupId!); // Agar faol guruh bo'lsa, obuna bo'lish
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

  Future<void> joinGroupChat(int groupId) async {
    if (_activeGroupId == groupId && _isConnected)
      return; // Ulanish holatini ham tekshirish

    _unsubscribePrevious();
    _activeGroupId = groupId;

    try {
      await _loadMessages(groupId); // Xabarlarni yuklash
      if (_isConnected) {
        _subscribeToGroupChat(groupId);
      }
    } catch (e) {
      _logger.e("Failed to join group chat: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error,
          errorMessage: "Failed to join group chat"));
    }
  }

  void _unsubscribePrevious() {
    _unsubscribeCallback?.call();
    _unsubscribeCallback = null;
    _processedMessageIds.clear(); // Oldingi xabarlar IDlarini tozalash
  }

  Future<void> _subscribeToGroupChat(int groupId) async {
    final destination = '/topic/chat.$groupId';

    _unsubscribeCallback = _stompClient.subscribe(
      destination: destination,
      headers: {'id': 'groupchat-$groupId'},
      // `persistent` header olib tashlandi, chunki u hamma serverlar uchun ham to'g'ri bo'lmasligi mumkin
      callback: (frame) {
        if (frame.body == null) return;

        try {
          final data = jsonDecode(frame.body!);
          final messageId = data['id'].toString();

          // Xabar allaqachon qayta ishlangan bo'lsa yoki joriy foydalanuvchidan bo'lsa o'tkazib yuborish
          if (_processedMessageIds.contains(messageId)) return;
          if (data['senderId'].toString() == currentUser.id.toString()) return;

          _processedMessageIds.add(messageId); // Xabar IDni qo'shish

          final message = ChatMessage(
            id: int.parse(messageId),
            senderId: int.parse(data['senderId'].toString()),
            type: 'text',
            // `ChatCubit` dagi kabi
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

  Future<void> _loadMessages(int groupId) async {
    emit(state.copyWith(status: TeamChatStatus.loading));

    try {
      final groupChatModel = await _apiService.getChatFromApi(groupId);

      // A'zolarni `MemberModel`ga o'tkazish
      final members = groupChatModel.members
          .map((member) => MemberModel(
                id: member.id,
                userId: member.userId,
                username: member.userFullName ?? 'Unknown',
                // Null bo'lmasligi uchun
                joinedAt: member.joinedAt,
                userImage: member.userImage,
                position: '', // `ChatCubit`da bu maydon yo'q edi
              ))
          .toList();

      // Xabarlarni sanasi bo'yicha saralash
      final messages = groupChatModel.messages!
        ..sort((a, b) => a.sentAt.compareTo(b.sentAt)); // Eskidan yangiga

      // Pinlangan xabarlarni qayta ishlash
      final pinnedMessages = groupChatModel.pinnedMessages;

      emit(state.copyWith(
        status: TeamChatStatus.loaded,
        messages: messages,
        // Yangi xabarlar
        members: members,
        pinnedMessages: pinnedMessages,
        groupName: groupChatModel.name,
        chatModel: groupChatModel,
      ));
    } catch (e) {
      _logger.e("Failed to load messages: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error,
          errorMessage: "Failed to load messages"));
      rethrow; // Xatolikni yuqoriga uzatish
    }
  }

  void _addMessageToState(ChatMessage message) {
    final updatedMessages = [...state.messages, message]; // Oxiriga qo'shish

    emit(state.copyWith(messages: updatedMessages));
  }

  Future<void> sendMessage(String text) async {
    if (!_isConnected || _activeGroupId == null) {
      _logger.w("Cannot send message - not connected or no active group chat");
      return;
    }

    if (text.trim().isEmpty) return;

    final messageId = DateTime.now().millisecondsSinceEpoch; // long sifatida
    final timestamp = DateTime.now();

    // Optimistik xabar yaratish
    final optimisticMessage = ChatMessage(
      id: messageId,
      senderId: currentUser.id,
      type: 'text',
      content: text,
      sentAt: timestamp,
    );

    // Holatni darhol yangilash
    _addMessageToState(optimisticMessage);

    try {
      // Xabar ma'lumotlarini tayyorlash
      final data = {
        'id': messageId.toString(),
        'senderId': currentUser.id.toString(),
        'senderName': currentUser.userFullName,
        'content': text,
        'createdAt': timestamp.millisecondsSinceEpoch,
        'groupId': _activeGroupId,
        // Guruh IDsi qo'shildi
        'senderAvatarUrl': state.currentUser?.imageUrl,
        // Foydalanuvchi avatar URLi
      };

      // STOMP orqali yuborish
      _stompClient.send(
        destination: '/app/chat.send/$_activeGroupId',
        body: jsonEncode(data),
        headers: {'userId': currentUser.id.toString()}, // `ChatCubit` dagi kabi
      );

      _logger.i("Message sent successfully");
    } catch (e) {
      _logger.e("Failed to send message: $e");

      // Xatolik yuz berganda optimistik xabarni olib tashlash
      final filteredMessages =
          state.messages.where((msg) => msg.id != messageId).toList();
      emit(state.copyWith(messages: filteredMessages));
    }
  }

  Future<void> deleteMessageFromChat(int messageId) async {
    if (_activeGroupId == null) return;

    try {
      // Optimistik yangilash
      final updatedMessages =
          state.messages.where((msg) => msg.id != messageId).toList();
      emit(state.copyWith(messages: updatedMessages));

      // API chaqiruvi
      await _apiService.deleteMessage(
        chatId: _activeGroupId!,
        messageId: messageId,
      );

      _logger.i("Message deleted successfully");
    } catch (e) {
      _logger.e("Failed to delete message: $e");
      // Holatni tiklash uchun xabarlarni qayta yuklash
      await _loadMessages(_activeGroupId!);
    }
  }

  Future<void> deleteChat() async {
    if (_activeGroupId == null) return;

    try {
      await _apiService.deleteChat(chatId: _activeGroupId ?? -1);
      emit(state.copyWith(
        status: TeamChatStatus.initial,
        messages: [],
        pinnedMessages: [],
        members: [],
        groupName: '',
        activePinnedIndex: 0,
        isPinnedExpanded: false,
        currentUser: state.currentUser,
        chatModel: null,
      ));
      _activeGroupId = null;
      _unsubscribePrevious();
    } catch (e) {
      _logger.e("Failed to delete chat: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error, errorMessage: "Failed to delete chat"));
    }
  }

  // TeamChatCubit ichida

// ... (boshqa kodlar)

  Future<void> pinMessageToChat(int messageId) async {
    final chatId = _activeGroupId;
    if (chatId == null) return;

    try {
      _logger.i("📌 Pinning message $messageId in chat $chatId");
      // _apiService dan foydalanamiz
      await _apiService.pinMessage(chatId: chatId, messageId: messageId);

      // Pinlangan xabarlarni yangilash uchun chatni qayta yuklash
      // ChatCubit'dagidek _loadMessages ni chaqiramiz
      await _loadMessages(chatId); // _activeGroupId ham chatId bilan bir xil

      _logger.i("📌 Message $messageId pinned successfully.");
    } catch (e) {
      _logger.e("❌ Pin message failed: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error, errorMessage: "Failed to pin message"));
    }
  }

  Future<void> unpinMessageFromChat(int messageId) async {
    final chatId = _activeGroupId;
    if (chatId == null) return;
    try {
      _logger.i("📌 Unpinning message $messageId in chat $chatId");
      // _apiService dan foydalanamiz
      await _apiService.unpinMessage(
        chatId: chatId,
        // _activeGroupId ?? -1 o'rniga to'g'ridan-to'g'ri chatId
        messageId: messageId,
      );

      // Pinlangan xabarlarni yangilash uchun chatni qayta yuklash
      // ChatCubit'dagidek _loadMessages ni chaqiramiz
      await _loadMessages(chatId); // _activeGroupId ham chatId bilan bir xil

      _logger.i("📌 Message $messageId unpinned successfully.");
    } catch (e) {
      _logger.e("❌ Unpin message failed: $e");
      emit(state.copyWith(
          status: TeamChatStatus.error,
          errorMessage: "Failed to unpin message"));
    }
  }

// ... (boshqa kodlar)

  void changePinnedMessageIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < state.pinnedMessages.length) {
      emit(state.copyWith(activePinnedIndex: newIndex));
    }
  }

  void togglePinnedMessagesExpanded() {
    emit(state.copyWith(isPinnedExpanded: !state.isPinnedExpanded));
  }

  void resetState() {
    _unsubscribePrevious();
    _activeGroupId = null;
    _processedMessageIds.clear(); // _messageIds o'rniga _processedMessageIds

    emit(TeamChatState(
      messages: [],
      status: TeamChatStatus.initial,
      members: [],
      pinnedMessages: [],
      groupName: '',
      activePinnedIndex: 0,
      isPinnedExpanded: false,
      currentUser: state.currentUser,
      chatModel: state.chatModel,
    ));
  }

  @override
  Future<void> close() async {
    _logger.i("Disposing TeamChatCubit");

    _unsubscribePrevious();
    _reconnectTimer?.cancel(); // Taymerni bekor qilish

    if (_stompClient.connected) {
      _stompClient.deactivate();
    }

    return super.close();
  }
}
