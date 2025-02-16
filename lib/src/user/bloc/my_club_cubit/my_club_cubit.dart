import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maydon_go/src/common/constants/config.dart';
import '../../../common/model/userinfo_model.dart';

part 'my_club_state.dart';

class MyClubCubit extends Cubit<MyClubState> {
  MyClubCubit() : super(MyClubLoading()) {
    _loadUsers();
  }

  final List<UserInfo> _allUsers = []; // Barcha foydalanuvchilar
  final List<UserInfo> _connections = []; // Qo‘shilgan connectionlar

  void _loadUsers() {
    // Fake user data
    _allUsers.addAll($users);

    emit(MyClubLoaded(connections: _connections, searchResults: _allUsers));
  }

  void addConnection(UserInfo user) {
    if (!_connections.contains(user)) {
      _connections.add(user);
      emit(MyClubLoaded(connections: _connections, searchResults: _allUsers));
    }
  }

  void removeConnection(UserInfo user) {
    _connections.remove(user);
    emit(MyClubLoaded(connections: _connections, searchResults: _allUsers));
  }

  void searchUsers(String query) {
    if (query.isEmpty) {
      emit(MyClubLoaded(connections: _connections, searchResults: _allUsers));
      return;
    }

    final results = _allUsers.where((user) {
      return user.contactNumber != null &&
          user.contactNumber!.contains(query);
    }).toList();

    emit(MyClubLoaded(connections: _connections, searchResults: results));
  }
}
