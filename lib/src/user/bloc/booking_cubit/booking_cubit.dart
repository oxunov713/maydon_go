import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/model/stadium_model.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit()
      : super(BookingLoaded(
          selectedDate: DateTime.now().toIso8601String().split('T')[0],
          bookedSlots: [],
          selectedStadium: '',
        ));

// selectedDate getteri
  String get selectedDate {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).selectedDate;
    }
    return DateTime.now().toIso8601String().split(
        'T')[0]; // Agar state BookingLoaded bo'lmasa, bugungi sana qaytariladi
  }

  void setSelectedDate(String date) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  void addBookingSlot(TimeSlot slot) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      if (!currentState.bookedSlots.contains(slot)) {
        emit(currentState.copyWith(
          bookedSlots: [...currentState.bookedSlots, slot],
        ));
      }
    }
  }

  void removeBookingSlot(TimeSlot slot) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(
        bookedSlots: currentState.bookedSlots.where((s) => s != slot).toList(),
      ));
    }
  }

  void changeStadium(String stadiumName) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedStadium: stadiumName));
    }
  }

  bool isSlotBooked(TimeSlot slot) {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).bookedSlots.contains(slot);
    }
    return false;
  }
}
