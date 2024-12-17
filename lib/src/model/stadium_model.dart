// location_model.dart
class LocationModel {
  final String address;
  final double latitude;
  final double longitude;

  LocationModel({
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
  final double ratings;
  final LocationModel location;
  final Facilities facilities;
  final List<String> images;
  final List<AvailableSlot> availableSlots;

  Stadium({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.ratings,
    required this.location,
    required this.facilities,
    required this.images,
    required this.availableSlots,
  });
}

class AvailableSlot {
  final DateTime startTime;
  final DateTime endTime;

  AvailableSlot({
    required this.startTime,
    required this.endTime,
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
