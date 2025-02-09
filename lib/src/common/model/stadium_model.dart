import 'facilities_model.dart';
import 'location_model.dart';

class Stadium {
  final int id;
  final String name;
  final String description;
  final double price;
  final LocationModel location;
  final Facilities facilities;
  final double averageRating;

  final List<String> images;
  final List<dynamic> ratings;

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
  });

  factory Stadium.fromJson(Map<String, dynamic> json) {
    return Stadium(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      location: LocationModel.fromJson(json['location']),
      facilities: Facilities.fromJson(json['facilities']),
      averageRating: json['averageRating'],
      images: List<String>.from(json['images']),
      ratings: List<dynamic>.from(json['ratings']),
    );
  }
}
