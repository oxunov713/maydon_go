class Facilities {
  final bool? hasBathroom;
  final bool? isIndoor;
  final bool? hasUniforms;

  Facilities({
    this.hasBathroom,
    this.isIndoor,
    this.hasUniforms,
  });

  factory Facilities.fromJson(Map<String, dynamic> json) {
    return Facilities(
      hasBathroom: json['hasBathroom'] as bool?,
      isIndoor: json['isIndoor'] as bool?,
      hasUniforms: json['hasUniforms'] as bool?,
    );
  }

  Facilities copyWith({
    bool? hasBathroom,
    bool? isIndoor,
    bool? hasUniforms,
  }) {
    return Facilities(
      hasBathroom: hasBathroom ?? this.hasBathroom,
      isIndoor: isIndoor ?? this.isIndoor,
      hasUniforms: hasUniforms ?? this.hasUniforms,
    );
  }
}
