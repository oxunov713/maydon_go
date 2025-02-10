import '../../../common/model/stadium_model.dart';

abstract class SavedStadiumsState {}

class SavedStadiumsInitialState extends SavedStadiumsState {}

class SavedStadiumsLoadedState extends SavedStadiumsState {
  final List<Stadium> savedStadiums;

  SavedStadiumsLoadedState({required this.savedStadiums});
}