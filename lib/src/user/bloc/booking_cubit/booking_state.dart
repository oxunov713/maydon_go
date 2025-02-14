import '../../../common/model/stadium_model.dart';

abstract class BookingState {
  const BookingState();
}

class BookingLoaded extends BookingState {
  final String selectedDate;
  final List<TimeSlot> bookedSlots;
  final String selectedStadium;

  BookingLoaded({
    required this.selectedDate,
    required this.bookedSlots,
    required this.selectedStadium,
  });

  // copyWith metodi
  BookingLoaded copyWith({
    String? selectedDate,
    List<TimeSlot>? bookedSlots,
    String? selectedStadium,
  }) {
    return BookingLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      selectedStadium: selectedStadium ?? this.selectedStadium,
    );
  }
}
