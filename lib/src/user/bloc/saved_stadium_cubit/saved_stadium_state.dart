import '../../../common/model/stadium_model.dart';

abstract class SavedStadiumsState {}

class SavedStadiumsInitialState extends SavedStadiumsState {}

class SavedStadiumsLoadedState extends SavedStadiumsState {
  final List<StadiumDetail> savedStadiums;

  SavedStadiumsLoadedState({required this.savedStadiums});
}