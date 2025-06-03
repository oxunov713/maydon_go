import 'package:dio/dio.dart';

import '../../model/chat_model.dart';
import '../../model/main_model.dart';
import '../../model/points_model.dart';
import '../../model/quiz_model.dart';
import '../../model/tournament_model.dart';

class CommonService {
  final Dio dio;

  CommonService(this.dio);

  Future<List<QuizPack>> getQuizWithPacks() async {
    try {
      final response = await dio.get('/pack/all/get');

      List jsonList = response.data as List;
      return jsonList
          .map((json) => QuizPack.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Quiz ma'lumotlarini olishda xatolik!");
    }
  }

  Future<Tournament> voteForTournaments(int tournamentId) async {
    try {
      final response = await dio.post('/tournament/$tournamentId/add');

      return Tournament.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Ovoz berishda xatolik!");
    }
  }

  Future<List<Tournament>> getTournaments() async {
    try {
      final response = await dio.get('/tournament/all');

      List data = response.data;
      return data.map((json) => Tournament.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Turnir ma'lumotlarini olishda xatolik!");
    }
  }

  Future<QuizPack> getQuizPack({required int quizPackId}) async {
    try {
      final response = await dio.get('/pack/$quizPackId/get');

      return QuizPack.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception("Quiz ma'lumotlarini olishda xatolik!");
    }
  }

  Future<ChatModel> getChatFromApi(int chatId) async {
    try {
      final response = await dio.get('/chat/$chatId/get');
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Chat ma'lumotlarini olishda xatolik: ${e.message}");
    }
  }

  Future<List<ChatModel>> getChatsFromApi() async {
    try {
      final response = await dio.get('/user/my/chats');
      List data = response.data;
      return data.map((json) => ChatModel.fromJson(json)).toList();
    } on DioException catch (e) {
      return [];
    }
  }

  Future<List<ChatModel>> getClubsChatsFromApi() async {
    try {
      final response = await dio.get('/user/my/clubs/chats');
      List data = response.data;
      return data.map((json) => ChatModel.fromJson(json)).toList();
    } on DioException catch (e) {
      return [];
    }
  }

  Future<List<UserPoints>> getLiderBoard({required int limit}) async {
    try {
      final response = await dio.get(
        '/user/top/by/points',
        queryParameters: {
          "limit": limit,
        },
      );

      List jsonList = response.data as List;
      return jsonList
          .map((json) => UserPoints.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchilar ma'lumotlarini olishda xatolik!");
    }
  }

  Future findUserByNumber({required int number}) async {
    try {
      final response = await dio.get("/user/find", queryParameters: {
        "number": number.toString(),
      });
      // Agar API array qaytarsa
      if (response.data is List) {
        return (response.data as List)
            .map((e) => UserModel.fromJson(e))
            .toList();
      }
      // Agar API bitta object qaytarsa
      else if (response.data is Map) {
        return [UserModel.fromJson(response.data as Map<String, dynamic>)];
      }
      // Agar javob bo'sh bo'lsa
      return [];
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  Future<void> pinMessage({required int chatId, required int messageId}) async {
    try {
      await dio.post("/chat/$chatId/messages/pinned/add", data: {
        "messageId": messageId,
      });
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
    }
  }

  Future<void> unpinMessage(
      {required int chatId, required int messageId}) async {
    try {
      await dio.delete(
        "/chat/$chatId/messages/pinned/remove",
        queryParameters: {
          "messageId": messageId,
        },
      );
    } catch (e) {
      if (e is DioException) {
        return e.response?.data;
      }
    }
  }

  Future<void> deleteMessage(
      {required int chatId, required int messageId}) async {
    try {
      await dio.delete("/chat/$chatId/message/$messageId/delete");
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
    }
  }

  Future<void> deleteChat({required int chatId}) async {
    try {
      await dio.delete("/chat/$chatId/messages/delete");
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
    }
  }
}
