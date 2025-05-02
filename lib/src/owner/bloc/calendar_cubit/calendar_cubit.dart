import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit()
      : super(CalendarState(
          selectedDay: DateTime.now(),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
        ));

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    emit(state.copyWith(selectedDay: selectedDay, focusedDay: focusedDay));
  }

  void changeFormat(CalendarFormat format) {
    emit(state.copyWith(calendarFormat: format));
  }
}
