import '../../../common/model/stadium_model.dart';

abstract class StadiumState {}

class StadiumInitial extends StadiumState {}

class StadiumLoading extends StadiumState {}

class StadiumLoaded extends StadiumState {
  final List<StadiumDetail> stadiums;
  final List<StadiumDetail> filteredStadiums;
  final List<int> currentIndexList;
  final bool isSearching;

  StadiumLoaded({
    required this.stadiums,
    required this.filteredStadiums,
    required this.currentIndexList,
    required this.isSearching,
  });

  StadiumLoaded copyWith({
    List<StadiumDetail>? filteredStadiums,
    List<int>? currentIndexList,
    bool? isSearching,
  }) {
    return StadiumLoaded(
      stadiums: stadiums,
      filteredStadiums: filteredStadiums ?? this.filteredStadiums,
      currentIndexList: currentIndexList ?? this.currentIndexList,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class StadiumError extends StadiumState {
  final String message;
  final int? errorCode;
  final bool isNetworkError; // Internet yo‘qligini tekshirish uchun flag

  StadiumError(this.message, {this.errorCode, this.isNetworkError = false});

  bool get isTokenExpired => errorCode == 401;

  bool get isServerError => errorCode != null && errorCode! >= 500;

  bool get isNotFound => errorCode == 404;

  bool get isForbidden => errorCode == 403;
}
