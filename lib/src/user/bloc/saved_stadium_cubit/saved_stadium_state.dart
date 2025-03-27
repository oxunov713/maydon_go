import '../../../common/model/stadium_model.dart';

abstract class SavedStadiumsState {}

class SavedStadiumsInitial extends SavedStadiumsState {}

class SavedStadiumsLoading extends SavedStadiumsState {}

class SavedStadiumsError extends SavedStadiumsState {
  final String message;

  SavedStadiumsError(this.message);
}

class SavedStadiumsLoaded extends SavedStadiumsState {
  final List<StadiumDetail> savedStadiums;

  SavedStadiumsLoaded({required this.savedStadiums});
}
