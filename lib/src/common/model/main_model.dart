import 'stadium_model.dart';
import 'userinfo_model.dart';

class MainModel {
  final int id;
  final String phoneNumber;
  final String role;
  final UserInfo? userInfo;
  final StadiumDetail? stadiumDetail;
  final bool active;

  MainModel({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.userInfo,
    this.stadiumDetail,
    required this.active,
  });

  factory MainModel.fromJson(Map<String, Object?> json) {
    return MainModel(
      id: json['id'] as int,
      phoneNumber: json['phoneNumber'] as String,
      role: json['role'] as String,
      userInfo: json['userInfo'] != null
          ? UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>)
          : null,
      stadiumDetail: json['stadium'] != null
          ? StadiumDetail.fromJson(json['stadium'] as Map<String, dynamic>)
          : null,
      active: json['active'] as bool,
    );
  }
}
