import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import 'package:maydon_go/src/common/tools/position_enum.dart';

class TeamState {
  final bool isLoading;
  final String? error;

  final List<UserModel> availablePlayers; // Users available to be added to the club
  final List<MemberModel> players; // Current club members
  final bool showPositions; // Toggle for displaying position abbreviations
  final ClubModel club; // The current club

  TeamState({
    required this.isLoading,
    required this.error,
    required this.availablePlayers,
    required this.players,
    required this.showPositions,
    required this.club,
  });

  // Factory for initial state
  factory TeamState.initial() {
    return TeamState(
      isLoading: false,
      error: null,
      availablePlayers: [],
      players: [],
      showPositions: false,
      club: ClubModel(
        id: -1,
        name: '',
        chatId: -1,
        members: [],
        ownerId: -1,
      ),
    );
  }

  // CopyWith method for updating state
  TeamState copyWith({
    bool? isLoading,
    String? error,
    List<UserModel>? availablePlayers,
    List<MemberModel>? players,
    bool? showPositions,
    ClubModel? club,
  }) {
    return TeamState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      availablePlayers: availablePlayers ?? this.availablePlayers,
      players: players ?? this.players,
      showPositions: showPositions ?? this.showPositions,
      club: club ?? this.club,
    );
  }
}