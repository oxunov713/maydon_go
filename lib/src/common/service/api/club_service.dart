import 'dart:io';

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

  Future<void> addMembers(
      {required int clubId,
      required String position,
      required int userId}) async {
    try {
      await dio.post("/club/$clubId/members/add", data: [
        {
          "userId": userId,
          "position": position,
        }
      ]);
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  Future<ClubModel> getClubInfo({required int clubId}) async {
    try {
      final response = await dio.get("/club/$clubId/info");
      return ClubModel.fromJson(response.data);
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

  Future<void> deleteClub({required int clubId}) async {
    try {
      await dio.delete("/club/$clubId/remove");
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  Future<void> updateClub(
      {required int clubId, required String clubName}) async {
    try {
      await dio.post("/club/$clubId/update", data: {
        "name": clubName,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  Future<void> updateClubImage({
    required int clubId,
    required File imageFile,
  }) async {
    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      await dio.post("/club/$clubId/image/set", data: formData);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data.toString());
      } else {
        throw Exception('Rasm yuklashda xatolik yuz berdi.');
      }
    }
  }

  Future<void> removeMember(
      {required int clubId, required int memberId}) async {
    try {
      await dio.delete("/club/$clubId/members/remove", data: {
        "membersId": [memberId]
      });
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data.toString());
      } else {
        throw Exception('remove member berdi.');
      }
    }
  }
}
