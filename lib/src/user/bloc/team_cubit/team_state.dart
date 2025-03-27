import '../../../common/model/main_model.dart';
import '../../../common/tools/position_enum.dart';

class TeamState {
  final bool isLoading;
  final String? error;
  final List<UserModel> availablePlayers;
  final Map<FootballPosition, UserModel?> players;
  final bool showPositions;

  TeamState({
    required this.isLoading,
    required this.error,
    required this.availablePlayers,
    required this.players,
    required this.showPositions,
  });

  factory TeamState.initial() {
    return TeamState(
      isLoading: false,
      error: null,
      availablePlayers: [],
      players: {},
      showPositions: false,
    );
  }

  TeamState copyWith({
    bool? isLoading,
    String? error,
    List<UserModel>? availablePlayers,
    Map<FootballPosition, UserModel?>? players,
    bool? showPositions,
  }) {
    return TeamState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      availablePlayers: availablePlayers ?? this.availablePlayers,
      players: players ?? this.players,
      showPositions: showPositions ?? this.showPositions,
    );
  }
}
