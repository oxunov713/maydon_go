part of 'my_club_cubit.dart';

abstract class MyClubState extends Equatable {
  const MyClubState();

  @override
  List<Object?> get props => [];
}

class MyClubLoading extends MyClubState {}

class MyClubLoaded extends MyClubState {
  final List<UserModel> connections;
  final List<UserModel> searchResults;

  const MyClubLoaded({required this.connections, required this.searchResults});

  @override
  List<Object?> get props => [connections, searchResults];
}
class MyClubError extends MyClubState {
  final String message;

  const MyClubError(this.message);

  @override
  List<Object?> get props => [message];
}
