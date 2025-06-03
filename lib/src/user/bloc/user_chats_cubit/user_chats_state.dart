import '../../../common/model/chat_model.dart';

abstract class UserChatsState {}

class UserChatsInitial extends UserChatsState {}

class UserChatsLoading extends UserChatsState {}

class UserChatsLoaded extends UserChatsState {
  final List<ChatModel> chats;
  final List<ChatModel> clubs;

  UserChatsLoaded(this.chats, this.clubs);
}

class UserChatsError extends UserChatsState {
  final String message;

  UserChatsError(this.message);
}
