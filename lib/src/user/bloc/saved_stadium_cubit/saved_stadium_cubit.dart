import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/model/stadium_model.dart';
import 'saved_stadium_state.dart';

class SavedStadiumsCubit extends Cubit<SavedStadiumsState> {
  List<Stadium> _savedStadiums = [];

  SavedStadiumsCubit() : super(SavedStadiumsInitialState());

  // Get the list of saved stadiums
  List<Stadium> get savedStadiums => _savedStadiums;

  // Add a stadium to the saved list
  void addStadiumToSaved(Stadium stadium) {
    if (!_savedStadiums.contains(stadium)) {
      _savedStadiums.add(stadium);
      emit(SavedStadiumsLoadedState(savedStadiums: _savedStadiums));
    }
  }

  // Remove a stadium from the saved list
  void removeStadiumFromSaved(Stadium stadium) {
    _savedStadiums.remove(stadium);
    emit(SavedStadiumsLoadedState(savedStadiums: _savedStadiums));
  }

  // Set the saved stadiums to a new list
  void setSavedStadiums(List<Stadium> stadiums) {
    _savedStadiums = stadiums;
    emit(SavedStadiumsLoadedState(savedStadiums: _savedStadiums));
  }

  // Check if a stadium is saved
  bool isStadiumSaved(Stadium stadium) {
    return _savedStadiums.contains(stadium);
  }
}