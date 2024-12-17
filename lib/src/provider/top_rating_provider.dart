import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import '../model/stadium_model.dart';
import '../data/fake_data.dart';

class TopRatingProvider extends ChangeNotifier {
  List<Stadium> _stadiums = [];
  List<int> _currentIndexList = [];

  List<Stadium> get stadiums => _stadiums;
  List<CarouselSliderController> _carouselControllers = [];

  List<int> get currentIndexList => _currentIndexList;

  TopRatingProvider() {
    fetchStadiums();
    initializeCarouselControllers(stadiums.length);
    _currentIndexList = List.generate(_stadiums.length, (index) => 0);
  }

// Initialize the carousel controllers based on the stadium list
  void initializeCarouselControllers(int stadiumCount) {
    _carouselControllers = List.generate(
      stadiumCount,
      (index) => CarouselSliderController(),
    );
    notifyListeners();
  }

// Accessor method to get carousel controllers
  CarouselSliderController getCarouselController(int index) {
    return _carouselControllers[index];
  }

  void updateCurrentIndex(int index, int stadiumIndex) {
    _currentIndexList[stadiumIndex] = index;
    notifyListeners();
  }

  void fetchStadiums() {
    _stadiums = FakeData.stadiumOwners.map((e) => e.stadium).toList()
      ..sort((a, b) => b.ratings.compareTo(a.ratings));
    notifyListeners();
  }

  Map<DateTime, List<AvailableSlot>> findEarliestDate(
      List<AvailableSlot> availableSlots) {
    if (availableSlots.isEmpty) return {};

    // Group slots by date (ignoring time)
    final Map<DateTime, List<AvailableSlot>> groupedByDate = {};
    for (var slot in availableSlots) {
      final date = DateTime(
          slot.startTime.year, slot.startTime.month, slot.startTime.day);
      groupedByDate.putIfAbsent(date, () => []).add(slot);
    }

    // Find the earliest date
    final earliestDate =
        groupedByDate.keys.reduce((a, b) => a.isBefore(b) ? a : b);

    // Return only the slots for the earliest date
    return {earliestDate: groupedByDate[earliestDate]!};
  }
}
