part of 'my_club_cubit.dart';

abstract class MyClubState extends Equatable {
  const MyClubState();

  @override
  List<Object> get props => [];

  @override
  String toString() => 'MyClubState'; // toString() metodini qayta yozamiz
}

class MyClubLoading extends MyClubState {
  @override
  String toString() => 'MyClubLoading'; // toString() metodini qayta yozamiz
}

class MyClubLoaded extends MyClubState {
  final UserModel user;
  final List<Friendship> connections;
  final List<UserModel> searchResults;
  final List<UserPoints> liderBoard;

  const MyClubLoaded({
    required this.user,
    required this.connections,
    required this.searchResults,
    required this.liderBoard,
  });

  @override
  List<Object> get props => [user, connections, searchResults, liderBoard];

  @override
  String toString() => 'MyClubLoaded(user: $user, connections: $connections, searchResults: $searchResults, liderBoard: $liderBoard)'; // toString() metodini qayta yozamiz
}

class MyClubError extends MyClubState {
  final String error;

  const MyClubError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'MyClubError(error: $error)'; // toString() metodini qayta yozamiz
}