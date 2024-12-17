import 'package:flutter/material.dart';
import '../model/stadium_model.dart';

class SavedStadiumsProvider extends ChangeNotifier {
  List<Stadium> _savedStadiums = [];

  List<Stadium> get savedStadiums => _savedStadiums;

  // Stadionni saqlash
  void addStadiumToSaved(Stadium stadium) {
    if (!_savedStadiums.contains(stadium)) {
      _savedStadiums.add(stadium);
      notifyListeners();
    }
  }

  // Stadionni olib tashlash
  void removeStadiumFromSaved(Stadium stadium) {
    _savedStadiums.remove(stadium);
    notifyListeners();
  }

  // Saqlangan stadionlarni to'liq olish
  void setSavedStadiums(List<Stadium> stadiums) {
    _savedStadiums = stadiums;
    notifyListeners();
  }

  bool isStadiumSaved(Stadium stadium) {
    return _savedStadiums.contains(stadium);
  }
}
