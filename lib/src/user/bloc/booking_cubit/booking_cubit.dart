import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/model/substadium_model.dart';
import '../../../common/model/time_slot_model.dart';
import '../../../common/service/api_service.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final apiService = ApiService();

  BookingCubit() : super(BookingInitial());

  String selectedStadium = '';
  String selectedDate = '';
  double position = 0.0;
  bool confirmed = false;
  List<TimeSlot> bookedSlots = []; // 📌 Band qilingan slotlarni saqlash

  /// 📌 **Stadionlar API dan olinadi**
  Future<void> fetchStadiums() async {
    emit(BookingLoading());
    try {
      final stadiums = await apiService.getAllStadiums();
      if (stadiums.isNotEmpty) {
        fetchAvailableSlots(stadiums.first); // 📌 Default birinchi stadion ko‘rsatiladi
      }
      emit(BookingStadiumsLoaded(stadiums));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }


  /// 📌 30 kunlik bo‘sh slotlarni qaytaradi (faqat band qilinganlar tashlab yuboriladi)
  /// 📌 30 kunlik bo‘sh slotlarni yaratish (band qilingan vaqtlarni olib tashlash)
  void fetchAvailableSlots(StadiumDetail stadium) {
    emit(BookingLoading());

    final now = DateTime.now();
    final next30Days = List.generate(30, (index) => now.add(Duration(days: index)));

    List<TimeSlot> allSlots = [];

    for (var day in next30Days) {
      DateTime slotStart = DateTime(day.year, day.month, day.day, 0, 0);
      DateTime slotEnd = slotStart.add(Duration(hours: 1));

      while (slotEnd.day == day.day) {
        allSlots.add(TimeSlot(startTime: slotStart, endTime: slotEnd));
        slotStart = slotEnd;
        slotEnd = slotStart.add(Duration(hours: 1));
      }
    }

    // 📌 Har bir substadiumdagi band qilingan vaqtlarni yig‘amiz
    final bookedTimes = stadium.fields
        ?.expand((field) => field.bookings ?? [])
        .toList() ??
        [];

    // 📌 Band qilingan vaqtlarni olib tashlaymiz
    allSlots.removeWhere((slot) {
      return bookedTimes.any((booking) =>
      slot.startTime!.isAtSameMomentAs(booking.startTime!) ||
          (slot.startTime!.isAfter(booking.startTime!) &&
              slot.startTime!.isBefore(booking.endTime!)));
    });

    // 📌 UI ni yangilash
    emit(BookingUpdated(
      selectedStadium: stadium.name ?? '',
      selectedDate: '',
      groupedSlots: _groupSlotsByDate(allSlots),
      position: position,
      confirmed: confirmed,
    ));
  }


  /// 📌 Slotlarni sanalar bo‘yicha guruhlash
  Map<String, List<TimeSlot>> _groupSlotsByDate(List<TimeSlot> slots) {
    final Map<String, List<TimeSlot>> groupedSlots = {};
    for (var slot in slots) {
      final dateKey = DateFormat("yyyy-MM-dd").format(slot.startTime!);
      groupedSlots.putIfAbsent(dateKey, () => []);
      groupedSlots[dateKey]!.add(slot);
    }
    return groupedSlots;
  }


  /// 📌 **Tanlangan stadion va sana yangilash**
  void setSelectedStadium(StadiumDetail stadium) {
    selectedStadium = stadium.name ?? '';
    fetchAvailableSlots(stadium); // 📌 Yangi stadion bo‘sh slotlarini yuklash
  }


  void setSelectedDate(String date) {
    selectedDate = date;
    _updateState();
  }

  /// 📌 **Slotlarni guruhlash**
  void getGroupedSlots(StadiumDetail stadium) {
    final selectedField = stadium.fields?.firstWhere(
      (field) => field.name == selectedStadium,
      orElse: () => Substadiums(id: 0, name: 'Nomaʼlum stadion', bookings: []),
    );

    final Map<String, List<TimeSlot>> groupedSlots = {};
    selectedField?.bookings?.forEach((slot) {
      final date =
          DateFormat("yyyy-MM-dd").format(slot.startTime ?? DateTime.now());
      if (!groupedSlots.containsKey(date)) {
        groupedSlots[date] = [];
      }
      groupedSlots[date]?.add(slot);
    });

    _updateState(groupedSlots: groupedSlots);
  }

  /// 📌 **Swipe tugmachani surish**
  void updatePosition(double delta, double maxWidth) {
    position += delta;
    if (position < 0) position = 0;
    if (position > maxWidth) position = maxWidth;
    _updateState();
  }

  /// 📌 **Swipe tasdiqlash**
  void confirmPosition(double confirmThreshold) {
    if (position >= confirmThreshold) {
      confirmed = true;
    } else {
      position = 0;
    }
    _updateState();
  }

  /// 📌 **Vaqt slotlarini boshqarish**
  void addBookingSlot(TimeSlot slot) {
    if (!bookedSlots.contains(slot)) {
      bookedSlots.add(slot);
      _updateState();
    }
  }

  void removeBookingSlot(TimeSlot slot) {
    bookedSlots.remove(slot);
    _updateState();
  }

  bool isSlotBooked(TimeSlot slot) {
    return bookedSlots.contains(slot);
  }

  /// 📌 **State yangilash**
  void _updateState({Map<String, List<TimeSlot>>? groupedSlots}) {
    emit(BookingUpdated(
      selectedStadium: selectedStadium,
      selectedDate: selectedDate,
      groupedSlots: groupedSlots ??
          (state is BookingUpdated
              ? (state as BookingUpdated).groupedSlots
              : {}),
      position: position,
      confirmed: confirmed,
    ));
  }
}
