import 'stadium_model.dart';
import 'userinfo_model.dart';

class UserModel {
  final int? id;
  final String? phoneNumber;
  final String? role;
  final UserInfo? userInfo;
  final SubscriptionModel? subscriptionModel;
  final int? point;
  final bool? active;

  UserModel({
    this.id,
    this.phoneNumber,
    this.role,
    this.userInfo,
    this.subscriptionModel,
    this.point,
    this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
      userInfo: json['userInfo'] != null
          ? UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>)
          : null,
      subscriptionModel: json['subscriptionModel'] != null
          ? SubscriptionModel.fromJson(
          json['subscriptionModel'] as Map<String, dynamic>)
          : null,
      point: json['point'] as int?,
      active: json['active'] as bool?,
    );
  }
}

class SubscriptionModel {
  final String? name;
  final String? description;
  final double? price;

  SubscriptionModel({
    this.name,
    this.description,
    this.price,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
