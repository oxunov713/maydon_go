import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/service/booking_service.dart';

part 'booking_history_state.dart';

class BookingHistoryCubit extends Cubit<BookingHistoryState> {
  final _bookingService = BookingHistoryService();

  BookingHistoryCubit() : super(BookingHistoryInitial()) {
    fetchBookingHistories();
  }

  Future<void> fetchBookingHistories() async {
    emit(BookingHistoryLoading());
    try {
      final histories = await _bookingService.getAllBookingHistories();
      emit(BookingHistoryLoaded(histories));
    } catch (e) {
      emit(BookingHistoryError('Failed to fetch booking histories: $e'));
    }
  }

  Future<void> deleteBookingHistory(String key) async {
    emit(BookingHistoryLoading());
    try {
      await _bookingService.deleteBooking(key);
      final updatedHistories = await _bookingService.getAllBookingHistories();
      emit(BookingHistoryLoaded(updatedHistories));
    } catch (e) {
      emit(BookingHistoryError('Failed to delete booking: $e'));
    }
  }

  Future<void> clearAllBookings() async {
    emit(BookingHistoryLoading());
    try {
      await _bookingService.clearAllBookings();
      emit(BookingHistoryLoaded([]));
    } catch (e) {
      emit(BookingHistoryError('Failed to clear bookings: $e'));
    }
  }
}
