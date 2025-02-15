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
          groupedSlots: {},
          position: 0.0,
          confirmed: false,
          dialogShown: false,
        ));

  // bookedSlots getteri
  List<TimeSlot> get bookedSlots {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).bookedSlots;
    }
    return []; // Agar state BookingLoaded bo'lmasa, bo'sh ro'yxat qaytariladi
  }

  // selectedDate getteri
  String get selectedDate {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).selectedDate;
    }
    return DateTime.now().toIso8601String().split('T')[0];
  }

  // selectedStadium getteri
  String get selectedStadium {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).selectedStadium;
    }
    return '';
  }

  // Slider pozitsiyasini yangilash
  void updatePosition(double delta, double width) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      double newPosition = currentState.position + delta;
      if (newPosition < 0) newPosition = 0;
      if (newPosition > width) newPosition = width;
      emit(currentState.copyWith(position: newPosition));
    }
  }

  // Slider tasdiqlash
  void confirmPosition(double width) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;

      if (!currentState.confirmed) {
        bool newConfirmed = currentState.position >= width;
        double newPosition = newConfirmed ? width : 0;

        emit(currentState.copyWith(
          position: newPosition,
          confirmed: newConfirmed,
          dialogShown: true,
        ));
      }
    }
  }

  // Sana tanlash
  void setSelectedDate(String date) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  // Stadion tanlash
  void setSelectedStadium(String stadium) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(selectedStadium: stadium));
    }
  }

  // Vaqt qo'shish
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

  // Vaqtni olib tashlash
  void removeBookingSlot(TimeSlot slot) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(
        bookedSlots: currentState.bookedSlots.where((s) => s != slot).toList(),
      ));
    }
  }

  // Barcha vaqtlarni tozalash
  void clearBookingSlots() {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(
          bookedSlots: [],
          confirmed: false,
          dialogShown: false,
          position: 0.0));
    }
  }

  // Dialog ko'rsatilganligini belgilash
  void setDialogShown(bool shown) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(dialogShown: shown));
    }
  }

  // Vaqt band qilinganligini tekshirish
  bool isSlotBooked(TimeSlot slot) {
    if (state is BookingLoaded) {
      return (state as BookingLoaded).bookedSlots.contains(slot);
    }
    return false;
  }

  // Vaqtlarni sanalar bo'yicha guruhlash
  void getGroupedSlots(StadiumDetail stadium) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      final Map<String, List<TimeSlot>> groupedSlots = {};

      // Stadionni topish
      for (var stadiumSlot in stadium.stadiumsSlots) {
        if (stadiumSlot.containsKey(selectedStadium)) {
          final slots = stadiumSlot[selectedStadium];

          if (slots != null) {
            for (var entry in slots.entries) {
              final DateTime dateKey = entry.key;
              final List<TimeSlot> timeSlots = entry.value;

              final String dateOnly = DateFormat("yyyy-MM-dd").format(dateKey);

              groupedSlots.putIfAbsent(dateOnly, () => []);

              groupedSlots[dateOnly]!.addAll(timeSlots);
            }
          }
        }
      }

      // Yangi state bilan UI-ni yangilash
      emit(currentState.copyWith(groupedSlots: groupedSlots));
    }
  }
}
