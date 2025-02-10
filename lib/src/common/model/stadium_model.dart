class Stadium {
  final int id;
  final String name;
  final String description;
  final double price;
  final LocationModel location;
  final Facilities facilities;
  final double averageRating;
  final List<String> images;
  final List<int> ratings;
  final Map<DateTime, List<TimeSlot>> availableSlots;

  Stadium({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.facilities,
    required this.averageRating,
    required this.images,
    required this.ratings,
    required this.availableSlots,
  });

  factory Stadium.fromJson(Map<String, dynamic> json) {
    var availableSlotsFromJson = <DateTime, List<TimeSlot>>{};
    json['availableSlots'].forEach((key, value) {
      availableSlotsFromJson[DateTime.parse(key)] =
      List<TimeSlot>.from(value.map((x) => TimeSlot.fromJson(x)));
    });

    return Stadium(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      location: LocationModel.fromJson(json['location']),
      facilities: Facilities.fromJson(json['facilities']),
      averageRating: json['averageRating'].toDouble(),
      images: List<String>.from(json['images']),
      ratings: List<int>.from(json['ratings']),
      availableSlots: availableSlotsFromJson,
    );
  }
}

class LocationModel {
  final String address;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }
}

class Facilities {
  final bool hasBathroom;
  final bool isIndoor;
  final bool hasUniforms;

  Facilities({
    required this.hasBathroom,
    required this.isIndoor,
    required this.hasUniforms,
  });

  factory Facilities.fromJson(Map<String, dynamic> json) {
    return Facilities(
      hasBathroom: json['hasBathroom'],
      isIndoor: json['isIndoor'],
      hasUniforms: json['hasUniforms'],
    );
  }
}

class TimeSlot {
  final DateTime startTime;
  final DateTime endTime;

  TimeSlot({
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
    );
  }
}