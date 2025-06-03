import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/model/team_model.dart';
import '../../../common/model/friend_model.dart';
import '../../../common/model/main_model.dart';
import '../../../common/model/points_model.dart';
import '../../../common/service/api/api_client.dart';
import '../../../common/service/api/club_service.dart';
import '../../../common/service/api/common_service.dart';
import '../../../common/service/api/user_service.dart';

part 'my_club_state.dart';

class MyClubCubit extends Cubit<MyClubState> {
  MyClubCubit() : super(MyClubLoading()) {
    loadData();
  }

  late UserModel user;
  List<UserModel> allUsers = [];
  List<Friendship> connections = [];
  List<UserPoints> _liderBoard = [];
  List<ClubModel> _clubs = [];

  Timer? _debounce;
  int limit = 10;
  final apiService = UserService(ApiClient().dio);
  final clubService = ClubService(ApiClient().dio);

  Future<void> loadData() async {
    emit(MyClubLoading());
    try {
      final results = await Future.wait([
        apiService.getAllUsers(),
        apiService.getFriends(),
        CommonService(ApiClient().dio).getLiderBoard(limit: limit),
        clubService.getClubs(),
        apiService.getUser(),
      ]);

      allUsers = List<UserModel>.from(results[0] as List);
      connections = List<Friendship>.from(results[1] as List);
      _liderBoard = List<UserPoints>.from(results[2] as List);
      _clubs = List<ClubModel>.from(results[3] as List);
      user = results[4] as UserModel;
      emit(MyClubLoaded(
        user: user,
        clubs: _clubs,
        liderBoard: _liderBoard,
        connections: connections,
        searchResults: allUsers,
      ));
    } catch (e) {
      emit(MyClubError("❌ Xatolik: ${e.toString()}"));
    }
  }

  Future<void> addConnection(UserModel friend) async {
    if (!isConnected(friend.id!)) {
      try {
        final newFriendshipsJson =
            await apiService.addToFriends(userId: friend.id!);
        final newFriendships = List<Friendship>.from(
            newFriendshipsJson.map((json) => Friendship.fromJson(json)));

        if (newFriendships.isNotEmpty) {
          // Create a NEW list instead of modifying the existing one
          final updatedConnections = List<Friendship>.from(connections)
            ..add(newFriendships.last);

          connections = updatedConnections;

          emit(MyClubLoaded(
            user: user,
            clubs: _clubs,
            liderBoard: _liderBoard,
            connections: updatedConnections,
            searchResults: allUsers,
          ));
        }
      } catch (e) {
        emit(MyClubError("Do'st qo'shishda xatolik: ${e.toString()}"));
      }
    }
  }

  Future<void> removeConnection(UserModel friend) async {
    if (isConnected(friend.id!)) {
      try {
        await apiService.removeFromFriends(userId: friend.id!);

        // Create a NEW filtered list instead of modifying in-place
        final updatedConnections =
            connections.where((f) => f.friend.id != friend.id).toList();

        connections = updatedConnections;

        emit(MyClubLoaded(
          user: user,
          clubs: _clubs,
          liderBoard: _liderBoard,
          connections: updatedConnections,
          searchResults: allUsers,
        ));
      } catch (e) {
        emit(MyClubError("Do'stni o'chirishda xatolik: ${e.toString()}"));
      }
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
          clubs: _clubs,
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
            clubs: _clubs,
            liderBoard: _liderBoard,
            connections: List.from(connections),
            searchResults: [],
          ));
          return;
        }

        final results = await CommonService(ApiClient().dio)
            .findUserByNumber(number: number);
        emit(MyClubLoaded(
          user: user,
          clubs: _clubs,
          liderBoard: _liderBoard,
          connections: List.from(connections),
          searchResults: results,
        ));
      } catch (e) {
        emit(MyClubError("Qidiruvda xatolik: ${e.toString()}"));
      }
    });
  }

  // ------[Club]-----
  Future<void> createClub(String name, String position) async {
    emit(MyClubLoading());
    try {
      await clubService.createClub(clubName: name, position: position);
      final newClubs = await clubService.getClubs();
      emit(
        MyClubLoaded(
            user: user,
            liderBoard: _liderBoard,
            connections: connections,
            searchResults: allUsers,
            clubs: newClubs),
      );
    } catch (e) {
      emit(MyClubError("Klub yaratishda xatolik: ${e.toString()}"));
    }
  }

  Future<void> deleteClub(int clubId) async {
    emit(MyClubLoading());
    try {
      await clubService.deleteClub(clubId: clubId);
      final newClubs = await clubService.getClubs();
      emit(
        MyClubLoaded(
            user: user,
            liderBoard: _liderBoard,
            connections: connections,
            searchResults: allUsers,
            clubs: newClubs),
      );
    } catch (e) {
      throw Exception("Klub o'chirishda xatolik: ${e.toString()}");
    }
  }

  Future<void> updateClub(int clubId, String clubName) async {
    emit(MyClubLoading());
    try {
      await clubService.updateClub(clubId: clubId, clubName: clubName);
      final newClubs = await clubService.getClubs();
      emit(
        MyClubLoaded(
            user: user,
            liderBoard: _liderBoard,
            connections: connections,
            searchResults: allUsers,
            clubs: newClubs),
      );
    } catch (e) {
      throw Exception("update club error: ${e.toString()}");
    }
  }

  Future<void> removeMember(
      {required int clubId, required int memberId}) async {
    emit(MyClubLoading());
    try {
      await clubService.removeMember(clubId: clubId, memberId: memberId);
      final newClubs = await clubService.getClubs();
      emit(
        MyClubLoaded(
            user: user,
            liderBoard: _liderBoard,
            connections: connections,
            searchResults: allUsers,
            clubs: newClubs),
      );
    } catch (e) {}
  }

  Future<void> updateClubImage(int clubId, String imagePath) async {
    emit(MyClubLoading());

    try {
      final imageFile = File(imagePath);

      if (!await imageFile.exists()) {
        emit(MyClubError("Rasm fayli topilmadi."));
        return;
      }

      await clubService.updateClubImage(
        clubId: clubId,
        imageFile: imageFile,
      );

      final updatedClubs = await clubService.getClubs();

      emit(
        MyClubLoaded(
          user: user,
          liderBoard: _liderBoard,
          connections: connections,
          searchResults: allUsers,
          clubs: updatedClubs,
        ),
      );
    } catch (e) {
      emit(MyClubError("Rasm yuklashda xatolik: ${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();

    return super.close();
  }
}
