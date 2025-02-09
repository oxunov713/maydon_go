abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingUpdated extends BookingState {
  final List<String> bookedSlots;

  BookingUpdated(this.bookedSlots);
}

class BookingDateChanged extends BookingState {
  final String selectedDate;

  BookingDateChanged(this.selectedDate);
}
