import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/model/points_model.dart';
import '../../../common/model/friend_model.dart';
import '../../../common/model/main_model.dart';
import '../../../common/service/api_service.dart';

part 'my_club_state.dart';

class MyClubCubit extends Cubit<MyClubState> {
  MyClubCubit() : super(MyClubLoading()) {
    loadData();
  }

  late UserModel user;
  List<UserModel> allUsers = [];
  List<Friendship> connections = [];
  List<UserPoints> _liderBoard = [];
  Timer? _debounce;
  int limit = 10;

  Future<void> loadData() async {
    try {
      print("Loading data...");
      final results = await Future.wait([
        ApiService().getAllUsers(),
        ApiService().getFriends(),
        ApiService().getLiderBoard(limit: limit),
      ]);
      print("Finished fetching users, friends, and leaderboard.");

      user = await ApiService().getUser();
      print("Fetched user: ${user.id}");

      allUsers = List<UserModel>.from(results[0]);connections = results[1] as List<Friendship>;
      _liderBoard = results[2] as List<UserPoints>;

      emit(MyClubLoaded(
        user: user,
        liderBoard: _liderBoard,
        connections: List.from(connections),
        searchResults: List.from(allUsers),
      ));
      print("Emitted MyClubLoaded");
    } catch (e) {
      print("ERROR in loadData: $e");
      emit(MyClubError("❌ Xatolik: ${e.toString()}"));
    }
  }


  /// Foydalanuvchini do'stlar ro'yxatiga qo'shish yoki olib tashlash
  void toggleConnection(UserModel friend) async {
    if (isConnected(friend.id!)) {
      await removeConnection(friend);
    } else {
      await addConnection(friend);
    }
  }

  /// Yangi foydalanuvchini do'stlar ro'yxatiga qo'shish
  Future<void> addConnection(UserModel friend) async {
    if (!isConnected(friend.id!)) {
      final newFriendshipsJson =
          await ApiService().addToFriends(userId: friend.id!);
      final newFriendships = List<Friendship>.from(
          newFriendshipsJson.map((json) => Friendship.fromJson(json)));

      if (newFriendships.isNotEmpty) {
        connections.add(newFriendships
            .last); // Oxirgi qo'shilgan Friendship obyektini olamiz
        emit(MyClubLoaded(
          liderBoard: _liderBoard,
          user: user,
          connections: List.from(connections),
          searchResults: List.from(allUsers),
        ));
      }
    }
  }

  /// Foydalanuvchini do'stlar ro'yxatidan olib tashlash
  Future<void> removeConnection(UserModel friend) async {
    if (isConnected(friend.id!)) {
      await ApiService().removeFromFriends(userId: friend.id!);
      connections.removeWhere((f) => f.friend.id == friend.id);

      emit(MyClubLoaded(
        user: user,
        liderBoard: _liderBoard,
        connections: List.from(connections),
        searchResults: List.from(allUsers),
      ));
    }
  }

  /// Berilgan foydalanuvchi do'stlar ro'yxatida bor-yo'qligini tekshirish
  bool isConnected(int userId) {
    return connections.any((f) => f.friend.id == userId);
  }

  Future<void> searchUsers(String query) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        emit(MyClubLoaded(
          user: user,
          liderBoard: _liderBoard,
          connections: List.from(connections),
          searchResults: List.from(allUsers),
        ));
        return;
      }

      try {
        final number = int.tryParse(query);
        if (number == null) {
          emit(MyClubLoaded(
            user: user,
            liderBoard: _liderBoard,
            connections: List.from(connections),
            searchResults: [],
          ));
          return;
        }

        final results = await ApiService().findUserByNumber(number: number);
        emit(MyClubLoaded(
          user: user,
          liderBoard: _liderBoard,
          connections: List.from(connections),
          searchResults: results,
        ));
      } catch (e) {
        emit(MyClubError("Qidiruvda xatolik: ${e.toString()}"));
      }
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();

    return super.close();
  }
}
