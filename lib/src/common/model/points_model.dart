class UserPoints {
  final String? fullName;
  final String? imageUrl;
  final int points;

  UserPoints({
    this.fullName,
    this.imageUrl,
    required this.points,
  });

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      fullName: json['fullName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      points: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'imageUrl': imageUrl,
      'points': points,
    };
  }
}
