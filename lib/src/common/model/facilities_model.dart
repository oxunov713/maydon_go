// class Facilities {
//   final bool hasBathroom;
//   final bool isIndoor;
//   final bool hasUniforms;
//
//   Facilities({
//     required this.hasBathroom,
//     required this.isIndoor,
//     required this.hasUniforms,
//   });
//
//   factory Facilities.fromJson(Map<String, dynamic> json) {
//     return Facilities(
//       hasBathroom: json['hasBathroom'] ?? false, // Default to false if null
//       isIndoor: json['isIndoor'] ?? false,       // Default to false if null
//       hasUniforms: json['hasUniforms'] ?? false,  // Default to false if null
//     );
//   }
// }