import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/model/stadium_model.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit()
      : super(BookingLoaded(
    selectedDate: DateTime.now().toIso8601String().split('T')[0],
    bookedSlots: [],
    selectedStadium: '',
    groupedSlots: {}, // ⬅️ Bo‘sh map
  ));

  void setSelectedDate(String date) {
    emit((state as BookingLoaded).copyWith(selectedDate: date));
  }

  void addBookingSlot(TimeSlot slot) {
    final currentState = state as BookingLoaded;
    if (!currentState.bookedSlots.contains(slot)) {
      emit(currentState.copyWith(
        bookedSlots: [...currentState.bookedSlots, slot],
      ));
    }
  }

  void removeBookingSlot(TimeSlot slot) {
    final currentState = state as BookingLoaded;
    emit(currentState.copyWith(
      bookedSlots: currentState.bookedSlots.where((s) => s != slot).toList(),
    ));
  }

  void clearBooking() {
    emit(BookingLoaded(
      selectedDate: DateTime.now().toIso8601String().split('T')[0],
      bookedSlots: [],
      selectedStadium: '',
      groupedSlots: {},
    ));
  }

  void changeStadium(String stadiumName) {
    final currentState = state as BookingLoaded;
    emit(currentState.copyWith(selectedStadium: stadiumName));
  }

  bool isSlotBooked(TimeSlot slot) {
    return (state as BookingLoaded).bookedSlots.contains(slot);
  }

  void loadStadiumSlots(List<Map<String, Map<String, List<TimeSlot>>>> stadiumsSlots) {
    Map<String, List<TimeSlot>> groupedSlots = {};

    for (var stadium in stadiumsSlots) {
      for (var entry in stadium.entries) {
        String stadiumName = entry.key;
        Map<String, List<TimeSlot>> dateSlots = entry.value;

        for (var dateEntry in dateSlots.entries) {
          String date = dateEntry.key;
          List<TimeSlot> slots = dateEntry.value;

          if (!groupedSlots.containsKey(date)) {
            groupedSlots[date] = [];
          }
          groupedSlots[date]!.addAll(slots);
        }
      }
    }

    emit((state as BookingLoaded).copyWith(groupedSlots: groupedSlots));
  }
}
