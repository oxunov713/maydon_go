import 'package:table_calendar/table_calendar.dart';

class CalendarState {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;

  CalendarState({
    required this.selectedDay,
    required this.focusedDay,
    required this.calendarFormat,
  });

  CalendarState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    CalendarFormat? calendarFormat,
  }) {
    return CalendarState(
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
    );
  }
}