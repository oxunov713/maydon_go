import 'package:dio/dio.dart';
import 'package:maydon_go/src/common/model/team_model.dart';

class ClubService {
  final Dio dio;

  ClubService(this.dio);

  Future removeFromClub({required int clubId, required memberId}) async {
    try {
      final response = await dio.delete('/club/$clubId/members/remove', data: {
        "membersId": [memberId]
      });

      return response.data;
    } on DioException catch (e) {
      throw Exception("Quiz ma'lumotlarini olishda xatolik!");
    }
  }

//createClub
  Future<void> createClub(
      {required String clubName, required String position}) async {
    try {
      await dio.post(
        "/club/create",
        data: {
          "clubName": clubName,
          "ownerPosition": position,
        },
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  //getClubInfo
  Future<void> getClubInfo(
      {required String name, required int memberId}) async {
    try {
      await dio.post("/club/2/info", data: {
        "name": name,
        "membersId": [memberId]
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  Future<List<ClubModel>> getClubs() async {
    try {
      final response = await dio.get("/user/my/clubs");
      List data = response.data;
      return data.map((json) => ClubModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }
}
