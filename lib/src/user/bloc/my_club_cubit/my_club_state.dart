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
  final UserModel user;

  const MyClubLoaded(
      {required this.user,
      required this.connections,
      required this.searchResults});

  @override
  List<Object?> get props => [connections, searchResults];
}

class MyClubError extends MyClubState {
  final String message;
  final int? errorCode;
  final bool isNetworkError; // Internet yo‘qligini tekshirish uchun flag

  const MyClubError(this.message, {this.errorCode, this.isNetworkError = false});

  bool get isTokenExpired => errorCode == 401;

  bool get isServerError => errorCode != null && errorCode! >= 500;

  bool get isNotFound => errorCode == 404;

  bool get isForbidden => errorCode == 403;

  @override
  List<Object?> get props => [message];
}
