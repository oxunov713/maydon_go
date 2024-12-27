import 'package:flutter/material.dart';
import 'package:maydon_go/src/model/stadium_model.dart';

class BookingDateProvider extends ChangeNotifier {
  String _selectedDate = DateTime.now().toIso8601String();
  final List<AvailableSlot> _bookingList = [];

  String get selectedDate => _selectedDate;
  List<AvailableSlot> get bookingList => _bookingList;

  void setSelectedDate(String date) {
    if (_selectedDate != date) {
      _selectedDate = date;
      notifyListeners();
    }
  }

  void addBookingSlot(AvailableSlot slot) {
    if (!_bookingList.contains(slot)) {
      _bookingList.add(slot);
      notifyListeners();
    }
  }

  void removeBookingSlot(AvailableSlot slot) {
    if (_bookingList.contains(slot)) {
      _bookingList.remove(slot);
      notifyListeners();
    }
  }

  bool isSlotBooked(AvailableSlot slot) {
    return _bookingList.contains(slot);
  }
}