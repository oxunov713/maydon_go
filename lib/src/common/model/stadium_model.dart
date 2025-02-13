class StadiumDetail {
  final int id;
  final String name;
  final String description;
  final double price;
  final LocationModel location;
  final Facilities facilities;
  final double averageRating;
  final List<String> images;
  final List<int> ratings;
  final int stadiumCount;
  final List<Map<String, Map<DateTime, List<TimeSlot>>>> stadiumsSlots;

  StadiumDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.facilities,
    required this.averageRating,
    required this.images,
    required this.ratings,
    required this.stadiumCount,
    required this.stadiumsSlots,
  });

  factory StadiumDetail.fromJson(Map<String, dynamic> json) {
    // stadiumsSlots ni JSON dan o'qish
    final stadiumsSlotsFromJson = (json['stadiumsSlots'] as List).map((item) {
      final stadiumSlots = <String, Map<DateTime, List<TimeSlot>>>{};
      item.forEach((stadiumName, slots) {
        final availableSlots = <DateTime, List<TimeSlot>>{};
        slots.forEach((date, timeSlots) {
          availableSlots[DateTime.parse(date)] =
              (timeSlots as List).map((x) => TimeSlot.fromJson(x)).toList();
        });
        stadiumSlots[stadiumName] = availableSlots;
      });
      return stadiumSlots;
    }).toList();

    return StadiumDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      location: LocationModel.fromJson(json['location']),
      facilities: Facilities.fromJson(json['facilities']),
      averageRating: json['averageRating'].toDouble(),
      images: List<String>.from(json['images']),
      ratings: List<int>.from(json['ratings']),
      stadiumCount: json['stadiumCount'],
      stadiumsSlots: stadiumsSlotsFromJson,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StadiumDetail && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
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
