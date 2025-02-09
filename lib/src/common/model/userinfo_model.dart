class UserInfo {
  final String? firstName;
  final String? lastName;
  final String? imageUrl;
  final String? contactNumber;
  final String? telegramUsername;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.contactNumber,
    required this.telegramUsername,
  });

  factory UserInfo.fromJson(Map<String, Object?> json) {
    return UserInfo(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      contactNumber: json['contactNumber'] as String?,
      telegramUsername: json['telegramUsername'] as String?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'imageUrl': imageUrl,
      'contactNumber': contactNumber,
      'telegramUsername': telegramUsername,
    };
  }
}
