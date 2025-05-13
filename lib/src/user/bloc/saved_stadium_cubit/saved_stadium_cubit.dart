import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';
import '../../../common/model/stadium_model.dart';
import 'saved_stadium_state.dart';

class SavedStadiumsCubit extends Cubit<SavedStadiumsState> {
  final Map<int, StadiumDetail> _savedStadiums = {};
  final Map<int, bool> _loadingStates = {};
  final apiService = UserService(ApiClient().dio);

  SavedStadiumsCubit() : super(SavedStadiumsInitial()) {
    loadSavedStadiums();
  }

  /// Saqlangan stadionlarni yuklash
  Future<void> loadSavedStadiums() async {
    emit(SavedStadiumsLoading());
    try {
      final List<StadiumDetail> savedList = await apiService.getFavourites();
      _savedStadiums.clear();

      for (var stadium in savedList ?? []) {
        if (stadium.id != null) {
          _savedStadiums[stadium.id!] = stadium;
        }
      }
      emit(SavedStadiumsLoaded(savedStadiums: _savedStadiums.values.toList()));
    } catch (e) {
      emit(SavedStadiumsError('Failed to fetch saved stadiums: $e'));
    }
  }

  /// Stadionni saqlanganlarga qo‘shish
  Future<void> addStadiumToSaved(StadiumDetail stadium) async {
    if (stadium.id == null || _savedStadiums.containsKey(stadium.id)) return;

    _loadingStates[stadium.id!] = true;
    _notifyCurrentState();

    try {
      await apiService.addToFav(stadiumId: stadium.id!);
      _savedStadiums[stadium.id!] = stadium;
      _loadingStates[stadium.id!] = false;
      _notifyCurrentState();
    } catch (e) {
      _loadingStates[stadium.id!] = false;
      emit(SavedStadiumsError('Failed to add stadium: $e'));
    }
  }

  /// Stadionni saqlanganlardan o‘chirish
  Future<void> removeStadiumFromSaved(StadiumDetail stadium) async {
    if (stadium.id == null || !_savedStadiums.containsKey(stadium.id)) return;

    _loadingStates[stadium.id!] = true;
    _notifyCurrentState();

    try {
      await apiService.removeFromFav(stadiumId: stadium.id!);
      _savedStadiums.remove(stadium.id!);
      _loadingStates[stadium.id!] = false;
      _notifyCurrentState();
    } catch (e) {
      _loadingStates[stadium.id!] = false;
      emit(SavedStadiumsError('Failed to remove stadium: $e'));
    }
  }

  /// Joriy holatni yangilash uchun yordamchi metod
  void _notifyCurrentState() {
    emit(SavedStadiumsLoaded(savedStadiums: _savedStadiums.values.toList()));
  }

  /// Stadion saqlanganmi yoki yo‘qligini tekshirish
  bool isStadiumSaved(int stadiumId) => _savedStadiums.containsKey(stadiumId);

  /// Stadion uchun loading holatini olish
  bool isLoading(int stadiumId) => _loadingStates[stadiumId] ?? false;
}
