import 'package:equatable/equatable.dart';

import '../../../common/model/stadium_model.dart';
import '../../../common/model/time_slot_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingStadiumsLoaded extends BookingState {
  final List<StadiumDetail> stadiums;

  BookingStadiumsLoaded(this.stadiums);

  @override
  List<Object?> get props => [stadiums];
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingUpdated extends BookingState {
  final String selectedStadium;
  final String selectedDate;
  final Map<String, List<TimeSlot>> groupedSlots;
  final double position;
  final bool confirmed;

  BookingUpdated({
    required this.selectedStadium,
    required this.selectedDate,
    required this.groupedSlots,
    required this.position,
    required this.confirmed,
  });

  @override
  List<Object?> get props =>
      [selectedStadium, selectedDate, groupedSlots, position, confirmed];
}
