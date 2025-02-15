import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/model/stadium_model.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit()
      : super(BookingLoaded(
            selectedDate: DateTime.now().toIso8601String().split('T')[0],
            bookedSlots: [],
            selectedStadium: '',
            groupedSlots: {}));

  // bookedSlots getteri
  List<TimeSlot> get bookedSlots {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).bookedSlots;
    }
    return []; // Agar state BookingLoaded bo'lmasa, bo'sh ro'yxat qaytariladi
  }

  void updatePosition(double delta, double width) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      double newPosition = currentState.position + delta;
      if (newPosition < 0) newPosition = 0;
      if (newPosition > width) newPosition = width;
      emit(currentState.copyWith(position: newPosition));
    }
  }

  void confirmPosition(double width) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      bool newConfirmed = currentState.position >= width;
      double newPosition = newConfirmed ? width : 0;
      emit(currentState.copyWith(
          position: newPosition, confirmed: newConfirmed));
    }
  }

  // selectedDate getteri
  String get selectedDate {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).selectedDate;
    }
    return DateTime.now().toIso8601String().split(
        'T')[0]; // Agar state BookingLoaded bo'lmasa, bugungi sana qaytariladi
  }

  String get selectedStadium {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).selectedStadium;
    }
    return '';
  }

  void setSelectedDate(String date) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  void setSelectedStadium(String stadium) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedStadium: stadium));
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

  bool isSlotBooked(TimeSlot slot) {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).bookedSlots.contains(slot);
    }
    return false;
  }

  void getGroupedSlots(StadiumDetail stadium) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      final Map<String, List<TimeSlot>> groupedSlots = {};

      // **1. Stadion topilishi kerak**
      for (var stadiumSlot in stadium.stadiumsSlots) {
        if (stadiumSlot.containsKey(selectedStadium)) {
          final slots = stadiumSlot[selectedStadium]; // stadion nomi bilan bog‘liq vaqtlar

          if (slots != null) {
            for (var entry in slots.entries) {
              final DateTime dateKey = entry.key; // Sana (DateTime)
              final List<TimeSlot> timeSlots = entry.value; // Shu sanaga tegishli vaqtlar

              // **2. Sanani `yyyy-MM-dd` formatiga o‘tkazish**
              final String dateOnly = DateFormat("yyyy-MM-dd").format(dateKey);

              // **3. Agar sana mavjud bo‘lmasa, yangi ro‘yxat yaratish**
              groupedSlots.putIfAbsent(dateOnly, () => []);

              // **4. Shu sanaga tegishli vaqtlarni qo‘shish**
              groupedSlots[dateOnly]!.addAll(timeSlots);
            }
          }
        }
      }

      // **5. Yangi state bilan UI-ni yangilash**
      emit(currentState.copyWith(groupedSlots: groupedSlots));
    }
  }

}
