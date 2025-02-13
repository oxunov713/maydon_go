import '../../../common/model/stadium_model.dart';

abstract class BookingState {
  const BookingState();
}

class BookingLoaded extends BookingState {
  final String selectedDate;
  final List<TimeSlot> bookedSlots;
  final String selectedStadium;
  final Map<String, List<TimeSlot>> groupedSlots;

  BookingLoaded({
    required this.selectedDate,
    required this.bookedSlots,
    required this.selectedStadium,
    required this.groupedSlots,
  });

  BookingLoaded copyWith({
    String? selectedDate,
    List<TimeSlot>? bookedSlots,
    String? selectedStadium,
    Map<String, List<TimeSlot>>? groupedSlots,
  }) {
    return BookingLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      selectedStadium: selectedStadium ?? this.selectedStadium,
      groupedSlots: groupedSlots ?? this.groupedSlots,
    );
  }
}
