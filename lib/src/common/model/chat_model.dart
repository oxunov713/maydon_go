class ChatModel {
  final int id;
  final String name;
  final String type;
  final DateTime? createdDate;
  final List<ChatMember> members;
  final List<ChatMessage> messages;

  ChatModel({
    required this.id,
    required this.name,
    required this.type,
    this.createdDate,
    required this.members,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      createdDate: json['createdDate'] != null
          ? DateTime.tryParse(json['createdDate'])
          : null,
      members:
          (json['members'] as List).map((e) => ChatMember.fromJson(e)).toList(),
      messages: (json['messages'] as List)
          .map((e) => ChatMessage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'createdDate': createdDate?.toIso8601String(),
      'members': members.map((e) => e.toJson()).toList(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}

class ChatMember {
  final int id;
  final int userId;
  final String? userFullName;
  final String? userPhoneNumber;
  final String? userImage;
  final String? role;
  final DateTime joinedAt;

  ChatMember({
    required this.id,
    required this.userId,
    required this.role,
    required this.joinedAt,
     this.userFullName,
     this.userPhoneNumber,
     this.userImage,
  });

  factory ChatMember.fromJson(Map<String, dynamic> json) {
    return ChatMember(
      id: json['id'],
      userId: json['userId'],
      userFullName: json['userFullName'],
      userPhoneNumber: json['userPhoneNumber'],
      userImage: json['userImage'],
      role: json['role'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'role': role,
      'userFullName': userFullName,
      'userPhoneNumber': userPhoneNumber,
      'userImage': userImage,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}

class ChatMessage {
  final int id;
  final int senderId;
  final String type;
  final String content;
  final DateTime sentAt;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.type,
    required this.content,
    required this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['senderId'],
      type: json['type'],
      content: json['content'],
      sentAt: DateTime.parse(json['sentAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'type': type,
      'content': content,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
