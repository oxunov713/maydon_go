import 'main_model.dart';

class Friendship {

  final int chatId;
  final UserModel friend;
  final DateTime createdAt;

  Friendship({

    required this.friend,
    required this.chatId,
    required this.createdAt,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(

      chatId: json['chatId'] as int,
      friend: UserModel.fromJson(json['friend']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
