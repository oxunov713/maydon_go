// class AvailableSlot {
//   final DateTime startTime;
//   final DateTime endTime;
//
//   AvailableSlot({
//     required this.startTime,
//     required this.endTime,
//   });
//
//   factory AvailableSlot.fromJson(Map<String, dynamic> json) {
//     return AvailableSlot(
//       startTime: DateTime.parse(json['startTime']),
//       endTime: DateTime.parse(json['endTime']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'startTime': startTime.toIso8601String(),
//       'endTime': endTime.toIso8601String(),
//     };
//   }
// }