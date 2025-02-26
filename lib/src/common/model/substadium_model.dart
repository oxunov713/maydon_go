import 'time_slot_model.dart';

class Substadiums {
  final int? id;
  final String? name;
  final List<TimeSlot>? bookings;

  Substadiums({this.id, this.name, this.bookings});

  factory Substadiums.fromJson(Map<String, dynamic> json) {
    return Substadiums(
      id: json['id'] as int?,
      name: json['name'] as String?,
      bookings: (json['bookings'] as List?)
          ?.map((e) => TimeSlot.fromJson(e))
          .toList(),
    );
  }
}
