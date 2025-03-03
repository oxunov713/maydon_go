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

  Future _loadUsers() async {
    try {
      final results = await Future.wait([
        ApiService().getAllUsers(),
        ApiService().getFriends(),
      ]);

      _allUsers = results[0]; // getAllUsers natijasi
      _connections = results[1]; // getFriends natijasi

      emit(MyClubLoaded(
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
        connections: List.from(_connections),
        searchResults: List.from(_allUsers),
      ));
    }
  }

  void removeConnection(UserModel user) async {
    //await ApiService().removeFromFriends(userId: user.id!);
    _connections.remove(user);
    emit(MyClubLoaded(
      connections: List.from(_connections),
      searchResults: List.from(_allUsers),
    ));
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      emit(MyClubLoaded(
        connections: List.from(_connections),
        searchResults: List.from(_allUsers),
      ));
      return;
    }

    final results = _allUsers.where((user) {
      return user.contactNumber != null && user.contactNumber!.contains(query);
    }).toList();

    emit(MyClubLoaded(
      connections: List.from(_connections),
      searchResults: List.from(results),
    ));
  }
}
