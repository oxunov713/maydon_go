import 'package:maydon_go/src/common/model/time_slot_model.dart';

class UserModel {
  final int? id;
  final String? phoneNumber;
  final String? role;
  final SubscriptionModel? subscriptionModel;
  final int? point;
  final bool? active;
  final String? fullName;
  final String? imageUrl;

  // Yangi maydonlar
  final String? lastMessage; // Oxirgi xabar
  final String? time; // Oxirgi muloqot vaqti
  final bool? isOnline; // Onlayn holati
  final int? unreadCount; // O'qilmagan xabarlar soni

  UserModel({
    this.fullName,
    this.imageUrl,
    this.id,
    this.phoneNumber,
    this.role,
    this.subscriptionModel,
    this.point,
    this.active,
    this.lastMessage,
    this.time,
    this.isOnline,
    this.unreadCount,
  });

  UserModel copyWith({
    int? id,
    String? phoneNumber,
    String? role,
    SubscriptionModel? subscriptionModel,
    int? point,
    bool? active,
    String? fullName,
    String? imageUrl,
    String? lastMessage,
    String? time,
    bool? isOnline,
    int? unreadCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      subscriptionModel: subscriptionModel ?? this.subscriptionModel,
      point: point ?? this.point,
      active: active ?? this.active,
      fullName: fullName ?? this.fullName,
      imageUrl: imageUrl ?? this.imageUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      isOnline: isOnline ?? this.isOnline,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
      subscriptionModel: json['subscription'] != null
          ? SubscriptionModel.fromJson(json['subscription'])
          : null,
      point: json['points'] as int?,
      active: json['active'] as bool?,
      fullName: json['fullName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      lastMessage: json['lastMessage'] as String?, // Yangi maydonni qo'shish
      time: json['time'] as String?, // Yangi maydonni qo'shish
      isOnline: json['isOnline'] as bool?, // Yangi maydonni qo'shish
      unreadCount: json['unreadCount'] as int?, // Yangi maydonni qo'shish
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'role': role,
      'subscription': subscriptionModel?.toJson(),
      'points': point,
      'active': active,
      'fullName': fullName,
      'imageUrl': imageUrl,
      'lastMessage': lastMessage, // Yangi maydonni qo'shish
      'time': time, // Yangi maydonni qo'shish
      'isOnline': isOnline, // Yangi maydonni qo'shish
      'unreadCount': unreadCount, // Yangi maydonni qo'shish
    };
  }
}

class SubscriptionModel {
  final String? name;
  final String? description;
  final double? price;
  final int? durationInDays;
  final TimeSlot? timeSlot;

  SubscriptionModel({
    this.name,
    this.description,
    this.price,
    this.durationInDays,
    this.timeSlot
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      durationInDays: (json['durationInDays'] as num?)?.toInt(),
      timeSlot: TimeSlot.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'durationInDays': durationInDays,
      'timeSlot': timeSlot,
    };
  }
}
