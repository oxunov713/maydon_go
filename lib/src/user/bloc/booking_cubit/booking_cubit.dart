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
  String? selectedStadiumName;
  String? selectedDate;
  double position = 0.0;
  bool confirmed = false;

  BookingCubit() : super(BookingInitial());

  void rateStadium(int stadiumId, int rating) async {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      emit(currentState.copyWith(rating: rating));
    }
  }

  void sendRating() async {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;

      try {
        await ApiService()
            .rateTheStadium(currentState.stadium.id!, currentState.rating);
        emit(currentState.copyWith(rating: 0));
      } catch (e) {
        emit(BookingError('Xatolik yuz berdi: $e')); // Xato bo'lsa error
      }
    }
  }

  void setSelectedDate(String date) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;

      emit(
        BookingLoaded(
          user: currentState.user,
          stadium: currentState.stadium,
          bookedSlots: currentState.bookedSlots,
          selectedDate: date,
          selectedStadiumName: currentState.selectedStadiumName,
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

      // Set the initial selected stadium name
      selectedStadiumName = stadium.fields?.first.name ?? "No subStadium";

      _updateSlots(stadium, user);
    } catch (e) {
      emit(BookingError("Failed to fetch stadium: $e"));
    }
  }

  void setSelectedField(String fieldName) {
    if (state is BookingLoaded) {
      final currentState = state as BookingLoaded;
      selectedStadiumName = fieldName;
      Logger().i("Selected Stadium Name: $selectedStadiumName");

      final updatedFields = currentState.stadium.fields?.map((substadium) {
        if (substadium.name == fieldName) {
          final allSlots = _generateSlotsForDateRange(List.generate(
              30, (index) => DateTime.now().add(Duration(days: index))));
          final availableSlots =
              _removeBookedSlots(allSlots, substadium.bookings ?? []);
          return substadium.copyWith(availableSlots: availableSlots);
        } else {
          return substadium;
        }
      }).toList();

      emit(BookingLoaded(
        user: currentState.user,
        stadium: currentState.stadium.copyWith(fields: updatedFields),
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
    final today = now.toIso8601String().split("T")[0];

    final startDay = DateTime(now.year, now.month, now.day);
    final next30Days =
        List.generate(30, (index) => startDay.add(Duration(days: index)));

    final updatedFields = stadium.fields?.map((substadium) {
      final allSlots = _generateSlotsForDateRange(next30Days);
      final availableSlots =
          _removeBookedSlots(allSlots, substadium.bookings ?? []);
      log.e(
          "🔄 ${substadium.name} uchun yangi slotlar: ${availableSlots.length}");
      return substadium.copyWith(availableSlots: availableSlots);
    }).toList();

    emit(BookingLoaded(
      user: user,
      stadium: stadium.copyWith(fields: updatedFields),
      selectedDate: selectedDate?.isNotEmpty == true ? selectedDate : today,
      selectedStadiumName: selectedStadiumName,
    ));
    log.e("✅ State o‘zgardi: $state");
  }

  /// 30 kunlik 1 soatlik slotlarni generatsiya qilish
  List<TimeSlot> _generateSlotsForDateRange(List<DateTime> dates) {
    final List<TimeSlot> allSlots = [];
    final now = DateTime.now();

    for (var day in dates) {
      DateTime slotStart = DateTime(day.year, day.month, day.day, 0, 0);

      // If today, start from the next full hour
      if (day.day == now.day &&
          day.month == now.month &&
          day.year == now.year) {
        slotStart = DateTime(now.year, now.month, now.day, now.hour + 1, 0);
      }

      DateTime slotEnd = slotStart.add(const Duration(hours: 1));

      while (slotStart.day == day.day) {
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
    if (state is! BookingLoaded) {
      return;
    }

    final currentState = state as BookingLoaded;

    try {
      Logger().e(currentState.bookings);
      await ApiService().bookStadium(
          bookings: currentState.bookings, subStadiumId: subStadiumId);

      // To'g'ridan-to'g'ri refresh chaqiramiz
      await refreshStadium(currentState.stadium.id!);
    } catch (e) {
      print("❌ Bookingda xatolik: $e");
      emit(BookingError("Failed to confirm booking: $e"));
    }
  }

  /// Stadiumni yangilash (pull-to-refresh)
  Future<void> refreshStadium(int stadiumId) async {
    await fetchStadiumById(stadiumId);
  }
}
