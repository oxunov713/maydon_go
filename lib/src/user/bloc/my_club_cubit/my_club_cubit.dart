import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maydon_go/src/common/service/api_service.dart';

import '../../../common/constants/config.dart';
import '../../../common/model/main_model.dart';

part 'my_club_state.dart';

class MyClubCubit extends Cubit<MyClubState> {
  MyClubCubit() : super(MyClubLoading()) {
    _loadUsers();
  }

  List<UserModel> _allUsers = [];
  List<UserModel> _connections = [];
  late UserModel user;

  Future refreshUsers() {
    return _loadUsers();
  }

  Future _loadUsers() async {
    try {
      final results = await Future.wait([
        ApiService().getAllUsers(),
        ApiService().getFriends(),
      ]);
      user = await ApiService().getUser();
      _allUsers = results[0];
      _connections = results[1]; // getFriends natijasi

      emit(MyClubLoaded(
        user: user,
        connections: List.from(_connections),
        searchResults: List.from(_allUsers),
      ));
    } catch (e) {
      emit(MyClubError("❌ Xatolik: ${e.toString()}"));
    }
  }

  void addConnection(UserModel user) async {
    if (!_connections.contains(user)) {
      await ApiService().addToFriends(userId: user.id!);
      _connections.add(user);
      emit(MyClubLoaded(
        user: user,
        connections: List.from(_connections),
        searchResults: List.from(_allUsers),
      ));
    }
  }

  void removeConnection(UserModel user) async {
    // await ApiService().removeFromFriends(userId: user.id!);
    _connections.remove(user);
    emit(MyClubLoaded(
      user: user,
      connections: List.from(_connections),
      searchResults: List.from(_allUsers),
    ));
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(MyClubLoaded(
        user: user,
        connections: List.from(_connections),
        searchResults: List.from(_allUsers),
      ));
      return;
    }

    try {
      final result =
          await ApiService().findUserByNumber(number: int.tryParse(query) ?? 0);

      if (result != null) {
        emit(MyClubLoaded(
          user: user,
          connections: List.from(_connections),
          searchResults: [UserModel.fromJson(result)], // Faqat bitta natija
        ));
      } else {
        emit(MyClubLoaded(
          user: user,
          connections: List.from(_connections),
          searchResults: [],
        ));
      }
    } catch (e) {
      emit(MyClubError("🔍 Qidiruvda xatolik: ${e.toString()}"));
    }
  }
}
