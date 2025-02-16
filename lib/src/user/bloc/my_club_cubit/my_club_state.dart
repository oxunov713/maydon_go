part of 'my_club_cubit.dart';

abstract class MyClubState extends Equatable {
  const MyClubState();

  @override
  List<Object?> get props => [];
}

class MyClubLoading extends MyClubState {}

class MyClubLoaded extends MyClubState {
  final List<UserInfo> connections;
  final List<UserInfo> searchResults;

  const MyClubLoaded({required this.connections, required this.searchResults});

  @override
  List<Object?> get props => [connections, searchResults];
}
