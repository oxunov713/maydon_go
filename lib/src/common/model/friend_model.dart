import 'main_model.dart';

class Friendship {
  final int friendshipId;
  final int chatId;
  final UserModel friend;
  final DateTime createdAt;

  Friendship({
    required this.friendshipId,
    required this.friend,
    required this.chatId,
    required this.createdAt,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      friendshipId: json['friendshipId'] as int,
      chatId: json['chatId'] as int,
      friend: UserModel.fromJson(json['friend']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
