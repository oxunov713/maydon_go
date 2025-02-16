import '../../../common/model/stadium_model.dart';

abstract class SavedStadiumsState {}

class SavedStadiumsInitial extends SavedStadiumsState {}

class SavedStadiumsLoaded extends SavedStadiumsState {
  final List<StadiumDetail> savedStadiums;

  SavedStadiumsLoaded({required this.savedStadiums});
}