import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  // To store the selected date
  String selectedDate = '';

  // To store the booking status of each slot by date
  Map<String, List<String>> bookedSlots = {};

  // Update the selected date
  void setSelectedDate(String date) {
    selectedDate = date;
    emit(BookingDateChanged(selectedDate));
  }

  // Add slot to the booking list for the selected date
  void addSlot(String slot) {
    if (bookedSlots[selectedDate] == null) {
      bookedSlots[selectedDate] = [];
    }
    bookedSlots[selectedDate]!.add(slot);
    emit(BookingUpdated(bookedSlots[selectedDate]!));
  }

  // Remove slot from the booking list for the selected date
  void removeSlot(String slot) {
    bookedSlots[selectedDate]?.remove(slot);
    emit(BookingUpdated(bookedSlots[selectedDate]!));
  }

  // Check if a slot is booked for the selected date
  bool isSlotBooked(String slot) {
    return bookedSlots[selectedDate]?.contains(slot) ?? false;
  }

  // Remove all slots for the selected date
  void removeAllSlots() {
    bookedSlots[selectedDate]?.clear();
    emit(BookingUpdated(bookedSlots[selectedDate]!));
  }
}
