import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/model/stadium_model.dart';
import 'saved_stadium_state.dart';

class SavedStadiumsCubit extends Cubit<SavedStadiumsState> {
  List<StadiumDetail> _savedStadiums = [];

  SavedStadiumsCubit() : super(SavedStadiumsInitialState());

  // Get the list of saved stadiums
  List<StadiumDetail> get savedStadiums => _savedStadiums;

  // Add a stadium to the saved list
  void addStadiumToSaved(StadiumDetail stadium) {
    if (!_savedStadiums.any((e) => e.id == stadium.id)) {
      _savedStadiums.add(stadium);
      emit(SavedStadiumsLoadedState(savedStadiums: _savedStadiums));
    }
  }

  // Remove a stadium from the saved list
  void removeStadiumFromSaved(StadiumDetail stadium) {
    _savedStadiums.removeWhere(
      (element) => element.id == stadium.id,
    );
    emit(SavedStadiumsLoadedState(savedStadiums: _savedStadiums));
  }

  // Set the saved stadiums to a new list
  void setSavedStadiums(List<StadiumDetail> stadiums) {
    _savedStadiums = stadiums;
    emit(SavedStadiumsLoadedState(savedStadiums: _savedStadiums));
  }

  // Check if a stadium is saved
  bool isStadiumSaved(StadiumDetail stadium) {
    return _savedStadiums.any(
      (element) => element.id == stadium.id,
    );
  }
}
