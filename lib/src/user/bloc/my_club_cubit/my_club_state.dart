// my_club_state.dart
part of 'my_club_cubit.dart';

abstract class MyClubState extends Equatable {
  const MyClubState();

  @override
  List<Object?> get props => [];
}

class MyClubLoading extends MyClubState {}

class MyClubLoaded extends MyClubState {
  final UserModel user;
  final List<UserPoints> liderBoard;
  final List<Friendship> connections;
  final List<UserModel> searchResults;
  final List<ClubModel> clubs;

  const MyClubLoaded({
    required this.user,
    required this.liderBoard,
    required this.connections,
    required this.searchResults,
    required this.clubs,

  });

  @override
  List<Object?> get props =>
      [user, liderBoard, connections, searchResults, clubs];
}

class MyClubError extends MyClubState {
  final String error;

  const MyClubError(this.error);

  @override
  List<Object?> get props => [error];
}
