class Tournament {
  final int id;
  final String name;
  final String description;
  final int count;
  final int maxCount;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    required this.count,
    required this.maxCount,
  });

  // Factory constructor for creating an instance from a Map
  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      count: json['count'] as int,
      maxCount: json['maxCount'] as int,
    );
  }

  // Method to convert instance to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'count': count,
      'maxCount': maxCount,
    };
  }

  // CopyWith method to create a modified instance
  Tournament copyWith({
    int? id,
    String? name,
    String? description,
    int? count,
    int? maxCount,
  }) {
    return Tournament(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      count: count ?? this.count,
      maxCount: maxCount ?? this.maxCount,
    );
  }
}
