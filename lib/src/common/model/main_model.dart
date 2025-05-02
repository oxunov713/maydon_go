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

  UserModel({
    this.fullName,
    this.imageUrl,
    this.id,
    this.phoneNumber,
    this.role,
    this.subscriptionModel,
    this.point,
    this.active,
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
      point: json['point'] as int?,
      active: json['active'] as bool?,
      fullName: json['fullName'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
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
