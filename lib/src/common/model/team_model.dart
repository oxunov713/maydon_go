import 'main_model.dart';

class ClubModel {
  final int id;
  final String name;
  final String? imageUrl;
  final int chatId;
  final int ownerId;
  final List<MemberModel> members;

  ClubModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.chatId,
    required this.ownerId,
    required this.members,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      chatId: json['chatId'],
      ownerId: json['ownerId'],
      members: (json['members'] as List<dynamic>)
          .map((e) => MemberModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'chatId': chatId,
    'ownerId': ownerId,
    'members': members.map((e) => e.toJson()).toList(),
  };
}

class MemberModel {
  final int id;
  final int userId;
  final String username;
  final String? userImage;
  final String position;
  final DateTime joinedAt;

  MemberModel({
    required this.id,
    required this.userId,
    required this.username,
    this.userImage,
    required this.position,
    required this.joinedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      userImage: json['userImage'],
      position: json['position'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'id': id,
    'username': username,
    'userImage': userImage,
    'position': position,
    'joinedAt': joinedAt.toIso8601String(),
  };
}
