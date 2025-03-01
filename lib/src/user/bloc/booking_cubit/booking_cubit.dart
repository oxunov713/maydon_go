import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/model/time_slot_model.dart';
import '../../../common/service/api_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  List<TimeSlot> bookings = []; // Booking list
  String? selectedStadiumName;
  String? selectedDate;
  double position = 0.0;
  bool confirmed = false;

  BookingCubit() : super(BookingInitial());

  void setSelectedDate(String date) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;

      emit(BookingLoaded(
        stadium: currentState.stadium,
        bookedSlots: currentState.bookedSlots,
        selectedDate: date,
        selectedStadiumName:
            selectedStadiumName, // Stadionni yo‘qotmaslik uchun qo‘shildi
      ));
    }
  }

  /// API dan stadiumni ID bo‘yicha olib kelish
  Future<void> fetchStadiumById(int stadiumId) async {
    emit(BookingLoading());
    try {
      final stadium = await ApiService().getStadiumById(stadiumId: stadiumId);
      _updateSlots(stadium);
      selectedStadiumName = stadium.fields?.first.name;
    } catch (e) {
      emit(BookingError("Failed to fetch stadium: $e"));
    }
  }

  void setSelectedField(String fieldName) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      selectedStadiumName = fieldName;

      emit(BookingLoaded(
        stadium: currentState.stadium,
        bookedSlots: currentState.bookedSlots,
        selectedStadiumName: fieldName, // BU YERGA KIRITILDI
        selectedDate: currentState.selectedDate,
      ));
    }
  }

  bool isSlotBooked(TimeSlot slot) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      return currentState.bookings.any((bookedSlot) =>
      bookedSlot.startTime == slot.startTime &&
          bookedSlot.endTime == slot.endTime);
    }
    return false;
  }
  void updatePosition(double delta, double maxPosition) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      double newPosition = currentState.position + delta;
      if (newPosition < 0) newPosition = 0;
      if (newPosition > maxPosition) newPosition = maxPosition;

      emit(currentState.copyWith(position: newPosition));
    }
  }

  void confirmPosition(double maxPosition) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      final isConfirmed = currentState.position >= maxPosition;

      emit(currentState.copyWith(
        position: isConfirmed ? maxPosition : 0.0,
        confirmed: isConfirmed,
      ));
    }
  }

  /// Substadiumni tanlash (ID yoki nom bilan)
  void selectField({String? fieldName}) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      selectedStadiumName = fieldName;
      emit(BookingLoaded(
        stadium: currentState.stadium,
        bookedSlots: currentState.bookedSlots,
        selectedDate: currentState.selectedDate,
      ));
    }
  }

  /// Eski slotlarni o‘chirib, yangilarini qo‘shish
  void _updateSlots(StadiumDetail stadium) {
    final log = Logger();
    log.e("📅 Slotlarni yangilash...");

    final now = DateTime.now();
    final today = now.toIso8601String().split("T")[0]; // Bugungi sana

    final startDay = DateTime(now.year, now.month, now.day);
    final next30Days =
        List.generate(30, (index) => startDay.add(Duration(days: index)));

    final updatedFields = stadium.fields?.map((substadium) {
      final allSlots = _generateSlotsForDateRange(next30Days);
      final availableSlots =
          _removeBookedSlots(allSlots, substadium.bookings ?? []);
      return substadium.copyWith(availableSlots: availableSlots);
    }).toList();

    emit(BookingLoaded(
      stadium: stadium.copyWith(fields: updatedFields),
      selectedDate: selectedDate?.isNotEmpty == true
          ? selectedDate
          : today, // Default bugungi sana
    ));
    log.e("✅ State o‘zgardi: $state"); // State yangilanganligini tekshirish
  }

  /// 30 kunlik 1 soatlik slotlarni generatsiya qilish
  List<TimeSlot> _generateSlotsForDateRange(List<DateTime> dates) {
    final List<TimeSlot> allSlots = [];
    final now = DateTime.now();

    for (var day in dates) {
      DateTime slotStart = DateTime(day.year, day.month, day.day, 0, 0);

      // Agar bugungi sana bo'lsa, hozirgi vaqtni keyingi to'liq soatga yaxlitlash
      if (day.day == now.day &&
          day.month == now.month &&
          day.year == now.year) {
        // Hozirgi vaqtni keyingi to'liq soatga yaxlitlash
        slotStart = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
      }

      DateTime slotEnd = slotStart.add(Duration(hours: 1));

      while (slotEnd.day == day.day) {
        if (slotStart.isAfter(now)) {
          // Faqat kelajakdagi slotlarni olish
          allSlots.add(TimeSlot(startTime: slotStart, endTime: slotEnd));
        }
        slotStart = slotEnd;
        slotEnd = slotStart.add(Duration(hours: 1));
      }
    }
    return allSlots;
  }

  /// API dan kelgan book qilingan slotlarni o‘chirib tashlash
  List<TimeSlot> _removeBookedSlots(
      List<TimeSlot> allSlots, List<TimeSlot> bookedSlots) {
    return allSlots.where((slot) {
      return !bookedSlots.any((booking) =>
          slot.startTime!.isAtSameMomentAs(booking.startTime!) ||
          (slot.startTime!.isAfter(booking.startTime!) &&
              slot.startTime!.isBefore(booking.endTime!)));
    }).toList();
  }

  /// Booking Listga slot qo‘shish
  void addSlot(TimeSlot slot) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      final updatedBookings = List<TimeSlot>.from(currentState.bookings)..add(slot);
      emit(currentState.copyWith(bookings: updatedBookings));
    }
  }

  void removeSlot(TimeSlot slot) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      final updatedBookings = List<TimeSlot>.from(currentState.bookings)..remove(slot);
      emit(currentState.copyWith(bookings: updatedBookings));
    }
  }

  void clearSlots() {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(bookings: []));
    }
  }

  /// Bookingni tasdiqlash va API ga jo‘natish
  Future<void> confirmBooking() async {
    if (state is! BookingLoaded || bookings.isEmpty) return;

    final currentState = state as BookingLoaded;
    try {
      // await ApiService().bookSlots(bookings);
      bookings.clear(); // API ga jo‘natilgandan so‘ng tozalash
      emit(BookingLoaded(
        stadium: currentState.stadium,
        bookedSlots: [],
      ));
    } catch (e) {
      emit(BookingError("Failed to confirm booking: $e"));
    }
  }

  /// Stadiumni yangilash (pull-to-refresh)
  Future<void> refreshStadium(int stadiumId) async {
    await fetchStadiumById(stadiumId);
  }
}
