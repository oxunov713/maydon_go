import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/stadium_service.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/model/time_slot_model.dart';
import '../../../common/service/booking_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  String? selectedStadiumName;
  String? selectedDate;
  double position = 0.0;
  bool confirmed = false;
  final StadiumService _apiService;
  final BookingHistoryService _bookingHistoryService;

  BookingCubit({
    StadiumService? apiService,
    BookingHistoryService? bookingHistoryService,
    Logger? logger,
  })  : _apiService = apiService ?? StadiumService(ApiClient().dio),
        _bookingHistoryService =
            bookingHistoryService ?? BookingHistoryService(),
        super(BookingInitial());

  void rateStadium(int stadiumId, int rating) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(rating: rating));
    }
  }

  Future<void> sendRating() async {
    final currentState = state;
    if (currentState is! BookingLoaded || currentState.stadium.id == null) {
      return;
    }

    try {
      await _apiService.rateTheStadium(
          currentState.stadium.id!, currentState.rating);
      emit(currentState.copyWith(
          rating:
              0)); // Yangi reytingni yuborib bo'lgach, bahoni nolga o'zgartirish
    } catch (e) {
      emit(BookingError('Xatolik yuz berdi: $e'));
    }
  }

  void setSelectedDate(String date) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  Future<void> fetchStadiumById(int stadiumId) async {
    emit(BookingLoading());
    try {
      final stadium = await _apiService.getStadiumById(stadiumId: stadiumId);
      final user = await UserService(ApiClient().dio).getUser();
      selectedStadiumName =
          stadium.fields?.firstOrNull?.name ?? "No subStadium";
      _updateSlots(stadium, user);
    } catch (e) {
      emit(BookingError("Failed to fetch stadium: $e"));
    }
  }

  void setSelectedField(String fieldName) {
    final currentState = state;
    if (currentState is! BookingLoaded || currentState.stadium.fields == null) {
      return;
    }

    selectedStadiumName = fieldName;


    final updatedFields = currentState.stadium.fields!.map((substadium) {
      if (substadium.name != fieldName) return substadium;

      final allSlots = _generateSlotsForDateRange(
        List.generate(30, (index) => DateTime.now().add(Duration(days: index))),
      );
      final availableSlots = _removeBookedSlots(
        allSlots,
        substadium.bookings?.map((b) => b.timeSlot).toList() ?? [],
      );
      return substadium.copyWith(availableSlots: availableSlots);
    }).toList();

    emit(currentState.copyWith(
      stadium: currentState.stadium.copyWith(fields: updatedFields),
      selectedStadiumName: fieldName,
    ));
  }

  bool isSlotBooked(TimeSlot slot) {
    final currentState = state;
    if (currentState is! BookingLoaded) return false;

    return currentState.bookings.any((bookedSlot) =>
        bookedSlot.startTime == slot.startTime &&
        bookedSlot.endTime == slot.endTime);
  }

  void updatePosition(double delta, double maxPosition) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      final newPosition =
          (currentState.position + delta).clamp(0.0, maxPosition);
      emit(currentState.copyWith(position: newPosition));
    }
  }

  void confirmPosition(double maxPosition) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      final isConfirmed = currentState.position >= maxPosition;
      emit(currentState.copyWith(
        position: isConfirmed ? maxPosition : 0.0,
        confirmed: isConfirmed,
      ));
    }
  }

  void _updateSlots(StadiumDetail stadium, UserModel user) {


    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final next30Days =
        List.generate(30, (index) => today.add(Duration(days: index)));

    final updatedFields = stadium.fields?.map((substadium) {
      final allSlots = _generateSlotsForDateRange(next30Days);
      final availableSlots = _removeBookedSlots(
        allSlots,
        substadium.bookings?.map((b) => b.timeSlot).toList() ?? [],
      );

      return substadium.copyWith(availableSlots: availableSlots);
    }).toList();

    emit(BookingLoaded(
      user: user,
      stadium: stadium.copyWith(fields: updatedFields),
      selectedDate: selectedDate ?? today.toIso8601String().split("T")[0],
      selectedStadiumName: selectedStadiumName,
    ));

  }

  List<TimeSlot> _generateSlotsForDateRange(List<DateTime> dates) {
    final List<TimeSlot> allSlots = [];
    final now = DateTime.now();

    for (final day in dates) {
      var slotStart = DateTime(day.year, day.month, day.day,
          day.isAtSameMomentAs(now) ? now.hour + 1 : 0, 0);
      var slotEnd = slotStart.add(const Duration(hours: 1));

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

  List<TimeSlot> _removeBookedSlots(
      List<TimeSlot> allSlots, List<TimeSlot> bookedSlots) {
    return allSlots
        .where((slot) => !bookedSlots.any((booking) =>
            slot.startTime!.isAtSameMomentAs(booking.startTime!) ||
            (slot.startTime!.isAfter(booking.startTime!) &&
                slot.startTime!.isBefore(booking.endTime!))))
        .toList();
  }

  void addSlot(TimeSlot slot) {
    final currentState = state;
    if (currentState is! BookingLoaded) return;

    final updatedBookings = [...currentState.bookings, slot];
    emit(currentState.copyWith(bookings: updatedBookings));
  }

  void removeSlot(TimeSlot slot) {
    final currentState = state;
    if (currentState is! BookingLoaded) return;

    final updatedBookings =
        currentState.bookings.where((s) => s != slot).toList();
    emit(currentState.copyWith(bookings: updatedBookings));
  }

  void clearSlots() {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(
          currentState.copyWith(bookings: [], confirmed: false, position: 0.0));
    }
  }

  Future<void> confirmBooking(int subStadiumId) async {
    final currentState = state;
    if (currentState is! BookingLoaded || currentState.stadium.id == null) {
      return;
    }

    try {
      await _apiService.bookStadium(
        bookings: currentState.bookings,
        subStadiumId: subStadiumId,
      );

      await _bookingHistoryService.saveBookingHistory(
        stadiumId: currentState.stadium.id!,
        stadiumName: currentState.stadium.name!,
        bookings: currentState.bookings,
        stadiumPhoneNumber: currentState.stadium.owner!.phoneNumber!,
      );

      await refreshStadium(currentState.stadium.id!);
    } catch (e) {
      emit(BookingError("Failed to confirm booking: $e"));
    }
  }

  Future<void> refreshStadium(int stadiumId) => fetchStadiumById(stadiumId);
}
