import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../common/model/tournament_model.dart';
import '../../../common/service/api_service.dart';
import '../../../common/service/shared_preference_service.dart';
import 'tournament_state.dart';

class TournamentCubit extends Cubit<TournamentState> {
  TournamentCubit() : super(TournamentInitial()) {
    loadTournaments();
  }

  List<Tournament> _tournaments = [];
  List<int> _votedList = [];

  Future<void> loadTournaments() async {
    emit(TournamentLoading());
    try {
      _tournaments = await ApiService().getTournaments();
      _votedList = await ShPService.getVotedTournaments();
      emit(TournamentLoaded(
          _tournaments, _votedList)); // _votedList ham uzatiladi
    } catch (e) {
      emit(TournamentError('Turnirlarni yuklashda xatolik: ${e.toString()}'));
    }
  }

  Future<void> voteForTournament(int tournamentId) async {
    try {
      final index = _tournaments.indexWhere((t) => t.id == tournamentId);
      if (index == -1) return;

      if (_tournaments[index].count >= _tournaments[index].maxCount) return;

      // Turnir ovoz sonini yangilash
      _tournaments[index] = _tournaments[index].copyWith(
        count: _tournaments[index].count + 1,
      );

      // API va SharedPreferences'ga saqlash
      await ApiService().voteForTournaments(tournamentId);
      await ShPService.saveVotedTournament(tournamentId);
      _votedList = await ShPService.getVotedTournaments();

      // Yangilangan holatni emit qilish
      emit(TournamentLoaded(List.from(_tournaments), _votedList));
    } catch (e) {
      emit(TournamentError('Ovoz berishda xatolik: ${e.toString()}'));
    }
  }

  bool isTourVoted(int tournamentId) {
    return _votedList.contains(tournamentId);
  }
}
