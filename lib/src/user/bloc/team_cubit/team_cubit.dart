import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/service/api_service.dart';

import '../../../common/model/main_model.dart';
import '../../../common/tools/position_enum.dart';
import 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamState.initial());

  final log = Logger();

  Future<void> loadFriends() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final response = await ApiService().getFriends();

      print('API Response Count: ${response.length}');
      print('API Response Data: $response');

      emit(state.copyWith(
        availablePlayers: response.map((f) => f.friend).toList(),
        isLoading: false,
      ));

      print('Updated State Players Count: ${state.availablePlayers.length}');
    } catch (e) {
      print('Error loading friends: $e');
      emit(state.copyWith(
        error: 'Error loading friends: $e',
        isLoading: false,
      ));
    }
  }



  void togglePositionVisibility() {
    emit(state.copyWith(showPositions: !state.showPositions));
  }

  void addFriendToPosition(FootballPosition position, UserModel friend) {
    final newPlayers = Map<FootballPosition, UserModel?>.from(state.players);
    newPlayers[position] = friend;
    emit(state.copyWith(players: newPlayers));
  }

  void removeFromPosition(FootballPosition position) {
    final newPlayers = Map<FootballPosition, UserModel?>.from(state.players);
    newPlayers[position] = null;
    emit(state.copyWith(players: newPlayers));
  }
}