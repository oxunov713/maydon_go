import 'main_model.dart';

class ClubModel {
  final int id;
  final String name;
  final String? imageUrl;
  final int chatId;
  final int ownerId;
  final List<UserModel> members;

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
          .map((e) => UserModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'chatId': chatId,
      'owner': ownerId,
      'members': members.map((e) => e.toJson()).toList(),
    };
  }
}
