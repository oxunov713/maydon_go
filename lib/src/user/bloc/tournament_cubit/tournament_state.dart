import '../../../common/model/tournament_model.dart';

abstract class TournamentState {}

class TournamentInitial extends TournamentState {}

class TournamentLoading extends TournamentState {}

class TournamentLoaded extends TournamentState {
  final List<Tournament> tournaments;
  final List<int> votedList;

  TournamentLoaded(this.tournaments, this.votedList);
}

class TournamentError extends TournamentState {
  final String message;

  TournamentError(this.message);
}