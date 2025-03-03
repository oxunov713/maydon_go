import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/model/time_slot_model.dart';
import '../../../common/service/api_service.dart';
import '../../../common/service/hive_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  List<TimeSlot> bookings = []; // Booking list
  String? selectedStadiumName;
  String? selectedDate;
  double position = 0.0;
  bool confirmed = false;
  final HiveService _hiveService = HiveService();

  BookingCubit() : super(BookingInitial());

  void setSelectedDate(String date) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;

      emit(
        BookingLoaded(
          user: currentState.user,
          stadium: currentState.stadium,
          bookedSlots: currentState.bookedSlots,
          selectedDate: date,
          selectedStadiumName: selectedStadiumName,
          bookings: currentState.bookings,
        ),
      );
    }
  }

  /// API dan stadiumni ID bo‘yicha olib kelish
  Future<void> fetchStadiumById(int stadiumId) async {
    emit(BookingLoading());
    try {
      final stadium = await ApiService().getStadiumById(stadiumId: stadiumId);
      final user = await ApiService().getUser();

      _updateSlots(stadium, user);
    } catch (e) {
      emit(BookingError("Failed to fetch stadium: $e"));
    }
  }

  void setSelectedField(String fieldName) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      selectedStadiumName = fieldName;

      emit(BookingLoaded(
        user: currentState.user,
        stadium: currentState.stadium,
        bookedSlots: currentState.bookedSlots,
        selectedStadiumName: fieldName,
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

  /// Eski slotlarni o‘chirib, yangilarini qo‘shish
  void _updateSlots(StadiumDetail stadium, UserModel user) {
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
      user: user,
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
        slotStart = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
      }

      DateTime slotEnd = slotStart.add(const Duration(hours: 1));

      while (slotStart.day == day.day) {
        // 🔥 Shartni slotStart.day bilan tekshirish
        if (slotStart.isAfter(now)) {
          allSlots.add(TimeSlot(startTime: slotStart, endTime: slotEnd));
        }
        slotStart = slotEnd;
        slotEnd = slotStart.add(const Duration(hours: 1));
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
    final currentState = state as BookingLoaded;
    if (state is BookingLoaded) {
      final updatedBookings = List<TimeSlot>.from(currentState.bookings)
        ..add(slot);
      emit(currentState.copyWith(bookings: updatedBookings));
    } else {
      emit(BookingLoaded(
        bookings: [slot],
        stadium: currentState.stadium,
        user: currentState.user,
      ));
    }
  }

  void removeSlot(TimeSlot slot) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      final updatedBookings = List<TimeSlot>.from(currentState.bookings)
        ..remove(slot);
      emit(currentState.copyWith(bookings: updatedBookings));
    }
  }

  void clearSlots() {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(bookings: [], confirmed: false, position: 0));
    }
  }

  /// Bookingni tasdiqlash va API ga jo‘natish
  Future<void> confirmBooking(int subStadiumId) async {
    if (state is! BookingLoaded || bookings.isEmpty) return;

    final currentState = state as BookingLoaded;
    try {
      // await ApiService().bookSlots(bookings);
     // _hiveService.saveBookings(
      //    bookings, currentState.stadium.id!, subStadiumId);
      bookings.clear(); // API ga jo‘natilgandan so‘ng tozalash
      emit(BookingLoaded(
        user: currentState.user,
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
