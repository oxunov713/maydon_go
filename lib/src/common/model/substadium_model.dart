import 'package:maydon_go/src/common/model/time_slot_model.dart';

class Substadiums {
  final int? id;
  final String? name;
  final List<TimeSlot>? bookings;
  final List<TimeSlot>? availableSlots; // ✅ Yangi maydon qo‘shildi

  Substadiums({this.id, this.name, this.bookings, this.availableSlots});

  factory Substadiums.fromJson(Map<String, dynamic> json) {
    return Substadiums(
      id: json['id'] as int?,
      name: json['name'] as String?,
      bookings: (json['bookings'] as List?)
          ?.map((e) => TimeSlot.fromJson(e))
          .toList(),
    );
  }

  /// ✅ `copyWith` metodi qo‘shildi
  Substadiums copyWith({
    int? id,
    String? name,
    List<TimeSlot>? bookings,
    List<TimeSlot>? availableSlots,
  }) {
    return Substadiums(
      id: id ?? this.id,
      name: name ?? this.name,
      bookings: bookings ?? this.bookings,
      availableSlots: availableSlots ?? this.availableSlots,
    );
  }
}
