class LocationModel {
  final String? city;
  final String? country;
  final String? street;
  final double? latitude;
  final double? longitude;

  LocationModel({
    this.city,
    this.country,
    this.street,
    this.latitude,
    this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'] as String?,
      country: json['country'] as String?,
      street: json['street'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
