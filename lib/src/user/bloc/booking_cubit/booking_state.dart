import '../../../common/model/stadium_model.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingDateUpdated extends BookingState {
  final String selectedDate;

   BookingDateUpdated(this.selectedDate);
}

class BookingUpdated extends BookingState {
  final List<TimeSlot> bookedSlots;

   BookingUpdated(this.bookedSlots);
}
