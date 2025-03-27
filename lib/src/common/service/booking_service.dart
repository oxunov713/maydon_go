import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/time_slot_model.dart';

class BookingHistoryService {
  static const String _bookingsKey = 'bookingHistory';
  late SharedPreferences _prefs;

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<Map<String, dynamic>>> getAllBookingHistories() async {
    await _init();
    final bookingsJson = _prefs.getStringList(_bookingsKey) ?? [];
    return bookingsJson.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  Future<void> deleteBooking(String key) async {
    await _init();
    final allBookings = await getAllBookingHistories();
    final updatedBookings = allBookings.where((b) {
      final bookingKey = '${b['stadiumId']}-${TimeSlot.fromJson(b['booking']).startTime?.toIso8601String() ?? ''}';
      return bookingKey != key;
    }).toList();

    await _prefs.setStringList(
        _bookingsKey,
        updatedBookings.map((b) => jsonEncode(b)).toList()
    );
  }

  Future<void> clearAllBookings() async {
    await _init();
    await _prefs.remove(_bookingsKey);
  }

  Future<void> saveBookingHistory({
    required int stadiumId,
    required String stadiumName,
    required String stadiumPhoneNumber,
    required List<TimeSlot> bookings,
  }) async {
    await _init();
    final existingBookings = await getAllBookingHistories();

    for (TimeSlot booking in bookings) {
      if (booking.startTime == null) continue;

      existingBookings.add({
        'stadiumId': stadiumId,
        'stadiumName': stadiumName,
        'stadiumPhoneNumber': stadiumPhoneNumber,
        'booking': booking.toJson(),
      });
    }

    await _prefs.setStringList(
        _bookingsKey,
        existingBookings.map((b) => jsonEncode(b)).toList()
    );
  }
}