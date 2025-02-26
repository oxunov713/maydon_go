import 'facilities_model.dart';
import 'location_model.dart';
import 'main_model.dart';
import 'substadium_model.dart';

class StadiumDetail {
  final int? id;
  final String? name;
  final String? description;
  final double? price;
  final UserModel? owner;
  final LocationModel? location;
  final Facilities? facilities;
  final double? averageRating;
  final List<String>? images;
  final List<int>? ratings;
  final int? stadiumCount;
  final List<Substadiums>? fields;

  StadiumDetail({
    this.id,
    this.name,
    this.description,
    this.price,
    this.owner,
    this.location,
    this.facilities,
    this.averageRating,
    this.images,
    this.ratings,
    this.stadiumCount,
    this.fields,
  });

  factory StadiumDetail.fromJson(Map<String, dynamic> json) {
    return StadiumDetail(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      owner: json['owner'] != null ? UserModel.fromJson(json['owner']) : null,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      facilities: json['facilities'] != null
          ? Facilities.fromJson(json['facilities'])
          : null,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
      ratings: (json['ratings'] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList(),
      stadiumCount: json['stadiumCount'] as int?,
      fields: (json['fields'] as List?)
          ?.map((e) => Substadiums.fromJson(e))
          .toList(),
    );
  }
}
