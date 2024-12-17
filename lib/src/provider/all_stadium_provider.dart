import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import '../data/fake_data.dart';
import '../model/stadium_model.dart';

class StadiumProvider with ChangeNotifier {
  List<Stadium> _stadiums = [];
  List<Stadium> _filteredStadiums = [];
  List<int> _currentIndexList = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  List<CarouselSliderController> _carouselControllers = [];

  List<Stadium> get filteredStadiums => _filteredStadiums;

  List<int> get currentIndexList => _currentIndexList;

  StadiumProvider() {
    _stadiums = fetchStadiums();
    _filteredStadiums = _stadiums;
    initializeCarouselControllers(_stadiums.length);
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

  void filterStadiums(String query) {
    if (query.isEmpty) {
      _filteredStadiums = _stadiums;
    } else {
      final matches = _stadiums
          .where((stadium) =>
              stadium.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      final others = _stadiums
          .where((stadium) =>
              !stadium.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _filteredStadiums = [...matches, ...others];
    }
    notifyListeners();
  }

  void toggleSearchMode() {
    isSearching = !isSearching;
    if (!isSearching) {
      searchController.clear();

      _filteredStadiums = _stadiums;
    }
    notifyListeners();
  }

  List<Stadium> fetchStadiums() {
    return FakeData.stadiumOwners.map((e) => e.stadium).toList();
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

  void updateCurrentIndex(int index, int stadiumIndex) {
    _currentIndexList[stadiumIndex] = index;
    notifyListeners();
  }

  void setFilteredStadiums(List<Stadium> stadiums) {
    _filteredStadiums = stadiums;
    notifyListeners();
  }

  DateTime _currentDate = DateTime.now();
  late Stadium _stadium;

  DateTime get currentDate => _currentDate;

  Stadium get stadium => _stadium;

  // Sana o'zgartirish
  void changeDate(DateTime newDate) {
    _currentDate = newDate;
    notifyListeners();
  }

  // Soatlarni filtrlaydi
  List<AvailableSlot> get filteredSlots {
    // Sana asosida soatlarni filtrlaymiz
    return _stadium.availableSlots.where((slot) {
      // Slotdagi vaqtni sana bilan taqqoslash
      DateTime slotDate = DateTime.parse(
          slot.startTime.toString().split(' ')[0]); // slotning sanasini olish
      return slotDate.isAtSameMomentAs(_currentDate) ||
          slotDate.isAfter(_currentDate);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
