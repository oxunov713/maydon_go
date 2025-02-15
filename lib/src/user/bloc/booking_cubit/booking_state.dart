import '../../../common/model/stadium_model.dart';

abstract class BookingState {
  const BookingState();
}

class BookingLoaded extends BookingState {
  final String selectedDate;
  final List<TimeSlot> bookedSlots;
  final String selectedStadium;
  final Map<String, List<TimeSlot>> groupedSlots;
  final double position;
  final bool confirmed;

  BookingLoaded({
    required this.groupedSlots,
    required this.selectedDate,
    required this.bookedSlots,
    required this.selectedStadium,
    this.position = 0.0,
    this.confirmed = false,
  });

  // copyWith method
  BookingLoaded copyWith({
    String? selectedDate,
    List<TimeSlot>? bookedSlots,
    String? selectedStadium,
    Map<String, List<TimeSlot>>? groupedSlots,
    double? position,
    bool? confirmed,
  }) {
    return BookingLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      selectedStadium: selectedStadium ?? this.selectedStadium,
      groupedSlots: groupedSlots ?? this.groupedSlots,
      position: position ?? this.position,
      confirmed: confirmed ?? this.confirmed,
    );
  }
}

class BookingConfirm extends BookingState {}