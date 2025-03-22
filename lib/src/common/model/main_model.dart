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
