import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';
import 'package:maydon_go/src/common/tools/position_enum.dart';

import '../../../common/model/main_model.dart';
import '../../../common/service/api/club_service.dart';
import 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  final ClubService _clubService;

  TeamCubit(this._clubService) : super(TeamState.initial());

  // Initialize the cubit with club data and fetch available players
  Future<void> initialize(int clubId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final club = await _clubService.getClubInfo(clubId: clubId);
      final availablePlayers = await _fetchAvailablePlayers();
      emit(state.copyWith(
        isLoading: false,
        club: club,
        availablePlayers: availablePlayers,
        players: club.members,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Mock method to fetch available players (replace with actual API call if needed)
  Future<List<UserModel>> _fetchAvailablePlayers() async {
    final response = await UserService(ApiClient().dio).getFriends();
    return response.map((friendship) => friendship.friend).toList();
  }

  // Toggle visibility of position labels
  void togglePositionVisibility() {
    emit(state.copyWith(showPositions: !state.showPositions));
  }

  // Add a player to a specific position in the club
  Future<void> addFriendToPosition(
      FootballPosition position, UserModel player) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _clubService.addMembers(
        clubId: state.club.id,
        position: position.abbreviation,
        userId: player.id!,
      );
      // Refresh club info after adding a member
      final updatedClub = await _clubService.getClubInfo(clubId: state.club.id);
      emit(state.copyWith(
        isLoading: false,
        club: updatedClub,
        players: updatedClub.members,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Remove a player from a position
  Future<void> removePlayerFromPosition(
      FootballPosition position, int memberId) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _clubService.removeFromClub(
          clubId: state.club.id, memberId: memberId);
      final updatedClub = await _clubService.getClubInfo(clubId: state.club.id);
      emit(state.copyWith(
        isLoading: false,
        club: updatedClub,
        players: updatedClub.members,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
