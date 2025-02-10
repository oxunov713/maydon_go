import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/model/stadium_model.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit() : super(BookingInitial());

  String selectedDate = DateTime.now().toIso8601String().split('T')[0];
  final List<TimeSlot> _bookedSlots = [];

  List<TimeSlot> get bookedSlots => _bookedSlots;

  void setSelectedDate(String date) {
    selectedDate = date;
    emit(BookingDateUpdated(date));
  }

  void addBookingSlot(TimeSlot slot) {
    _bookedSlots.add(slot);
    emit(BookingUpdated(_bookedSlots));
  }

  void removeBookingSlot(TimeSlot slot) {
    _bookedSlots.remove(slot);
    emit(BookingUpdated(_bookedSlots));
  }

  bool isSlotBooked(TimeSlot slot) {
    return _bookedSlots.contains(slot);
  }
}

