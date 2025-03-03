import 'package:hive/hive.dart';

import '../model/time_slot_model.dart';

class HiveService {
  static const String _boxName = 'bookingsBox';

  Future<Box<List<Map<String, dynamic>>>> get _box async {
    return await Hive.openBox<List<Map<String, dynamic>>>(_boxName);
  }

  /// Bookinglarni saqlash
  Future<void> saveBookings(List<TimeSlot> bookings, int stadiumId, int subStadiumId) async {
    final box = await _box;

    // TimeSlotlarni Map ga o'tkazish
    List<Map<String, dynamic>> bookingsData = bookings.map((slot) => slot.toJson()).toList();

    // Saqlash uchun ma'lumotlar
    Map<String, dynamic> data = {
      'stadiumId': stadiumId,
      'subStadiumId': subStadiumId,
      'bookings': bookingsData,
    };

    // Hive ga saqlash
    await box.put('bookings', [data]);
  }

  /// Bookinglarni olish
  Future<List<TimeSlot>> getBookings() async {
    final box = await _box;
    final data = box.get('bookings');

    if (data != null && data.isNotEmpty) {
      // Map dan TimeSlot ga o'tkazish
      return data.map<TimeSlot>((item) => TimeSlot.fromJson(item)).toList();
    }

    return [];
  }

  /// Bookinglarni tozalash
  Future<void> clearBookings() async {
    final box = await _box;
    await box.clear();
  }
}