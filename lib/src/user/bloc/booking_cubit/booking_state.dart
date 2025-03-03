import 'package:equatable/equatable.dart';
import '../../../common/model/main_model.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/model/time_slot_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final UserModel user; // Yangi maydon
  final StadiumDetail stadium;
  final List<TimeSlot>? bookedSlots;
  final String? selectedDate;
  final String? selectedStadiumName;
  final List<TimeSlot> bookings;
  final double position;
  final bool confirmed;

  const BookingLoaded({
    required this.user, // Yangi maydon
    required this.stadium,
    this.bookedSlots,
    this.selectedDate,
    this.selectedStadiumName,
    this.bookings = const [],
    this.position = 0.0,
    this.confirmed = false,
  });

  BookingLoaded copyWith({
    UserModel? user, // Yangi maydon
    StadiumDetail? stadium,
    List<TimeSlot>? bookedSlots,
    String? selectedDate,
    String? selectedStadiumName,
    List<TimeSlot>? bookings,
    double? position,
    bool? confirmed,
  }) {
    return BookingLoaded(
      user: user ?? this.user, // Yangi maydon
      stadium: stadium ?? this.stadium,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedStadiumName: selectedStadiumName ?? this.selectedStadiumName,
      bookings: bookings ?? this.bookings,
      position: position ?? this.position,
      confirmed: confirmed ?? this.confirmed,
    );
  }

  @override
  List<Object?> get props => [user, stadium, bookedSlots, selectedDate, bookings, position, confirmed];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
