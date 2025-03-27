part of 'booking_history_cubit.dart';

abstract class BookingHistoryState {}

class BookingHistoryInitial extends BookingHistoryState {}

class BookingHistoryLoading extends BookingHistoryState {}

class BookingHistoryLoaded extends BookingHistoryState {
  final List<Map<String, dynamic>> bookingHistories;

  BookingHistoryLoaded(this.bookingHistories);
}

class BookingHistoryError extends BookingHistoryState {
  final String message;

  BookingHistoryError(this.message);
}