// location_model.dart
class Location {
  final String address;
  final double latitude;
  final double longitude;

  Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

// facilities_model.dart
class Facilities {
  final bool hasBathroom;
  final bool hasRestroom;
  final bool hasUniforms;

  Facilities({
    required this.hasBathroom,
    required this.hasRestroom,
    required this.hasUniforms,
  });
}

class Stadium {
  final int id;
  final String description;
  final String name;
  final double price;
  final Location location;
  final Facilities facilities;
  final List<String> images;

  Stadium({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.facilities,
    required this.images,
  });
}

// user_info_model.dart
class UserInfo {
  final String firstName;
  final String lastName;
  final String imageUrl;
  final String contactNumber;
  final String telegramUsername;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.imageUrl,
    required this.contactNumber,
    required this.telegramUsername,
  });
}

class StadiumOwner {
  final int id;
  final String phoneNumber;
  final String role;
  final UserInfo userInfo;
  final Stadium stadium;
  final bool active;

  StadiumOwner({
    required this.id,
    required this.phoneNumber,
    required this.role,
    required this.userInfo,
    required this.stadium,
    required this.active,
  });
}
