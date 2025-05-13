import 'package:dio/dio.dart';

import '../../model/bank_card_model.dart';
import '../../model/friend_model.dart';
import '../../model/main_model.dart';
import '../../model/stadium_model.dart';

class UserService {
  final Dio dio;

  UserService(this.dio);

  Future<UserModel> getUser() async {
    try {
      final response = await dio.get('/user/info');
      return UserModel.fromJson(response.data);
    } on DioException {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  Future<List<SubscriptionModel>> getOwnerSubscription() async {
    try {
      final response = await dio.get('/subscriptions/owner');
      List list = response.data;
      return list.map((json) => SubscriptionModel.fromJson(json)).toList();
    } on DioException {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  Future<List<SubscriptionModel>> getClientSubscription() async {
    try {
      final response = await dio.get('/subscriptions/client');
      List list = response.data;
      return list.map((json) => SubscriptionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  Future<List<BankCard>> getUserDonation() async {
    try {
      final response = await dio.get('/donation/cards');
      List list = response.data;
      return list.map((json) => BankCard.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  //getAllUsers
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await dio.get('/user/all/info');

      List<dynamic> jsonList = response.data; // JSON list
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchilar ma'lumotlarini olishda xatolik!");
    }
  }

  //getFriends
  Future<List<Friendship>> getFriends() async {
    try {
      final response = await dio.get('/friendship/get');

      List jsonList = response.data as List;
      return jsonList
          .map((json) => Friendship.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchilar ma'lumotlarini olishda xatolik!");
    }
  }

  Future<UserModel> addCoinsToUser(int userId, int amount) async {
    try {
      final response = await dio
          .post('/user/$userId/coins/add', queryParameters: {"amount": amount});

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Ovoz berishda xatolik!");
    }
  }

  Future<UserModel> updateUserInfo({required String name}) async {
    try {
      final response = await dio.post('/user/update', data: {
        "fullName": name,
      });
      return UserModel.fromJson(response.data);
    } on DioException {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  } //Add to friends

  //Add to favourites
  Future<void> addToFav({required int stadiumId}) async {
    try {
      await dio
          .post("/user/favourites", queryParameters: {'stadiumId': stadiumId});
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  Future addToFriends({required int userId}) async {
    try {
      final response = await dio
          .post("/friendship/add", queryParameters: {"friendId": userId});

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      } else {
        throw Exception('Fav davomida xatolik yuz berdi: ${e.toString()}');
      }
    }
  }

  Future<void> removeFromFav({required int stadiumId}) async {
    try {
      final response = await dio.delete("/user/favourites/$stadiumId/remove");
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  //Get favourites
  Future<List<StadiumDetail>> getFavourites() async {
    try {
      final response = await dio.get('/user/favourites');

      // Agar `data` null bo‘lsa, bo‘sh list qaytaramiz
      if (response.data == null) {
        return [];
      }

      // Agar `response.data` `List` formatida bo‘lmasa, bo‘sh list qaytaramiz
      if (response.data is! List) {
        return [];
      }

      // Stadionlarni JSON dan obyektga o‘girish
      final List<StadiumDetail> stadiums = (response.data as List)
          .map((item) => StadiumDetail.fromJson(item))
          .toList();

      return stadiums;
    } on DioException catch (e) {
      // Agar status kodi 404 bo‘lsa, bo‘sh list qaytaramiz (xatolik emas)
      if (e.response?.statusCode == 404) {
        return [];
      }

      throw Exception('Error fetching stadiums: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching stadiums: $e');
    }
  }

  //Remove friends
  Future removeFromFriends({required int userId}) async {
    try {
      final response = await dio.delete("/friendship/$userId/remove");

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      } else {
        throw Exception('Fav davomida xatolik yuz berdi: ${e.toString()}');
      }
    }
  }
}
