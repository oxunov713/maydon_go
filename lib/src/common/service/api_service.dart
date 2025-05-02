import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/bank_card_model.dart';
import 'package:maydon_go/src/common/model/chat_model.dart';
import 'package:maydon_go/src/common/model/friend_model.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/model/quiz_model.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import 'package:maydon_go/src/common/model/time_slot_model.dart';
import 'package:maydon_go/src/common/model/tournament_model.dart';

import '../constants/config.dart';
import '../model/points_model.dart';
import '../model/stadium_model.dart';
import 'shared_preference_service.dart';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(
    BaseOptions(
      baseUrl: Config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await ShPService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            ShPService.clearAllData();
          }
          return handler.next(error);
        },
      ),
    );
  }

  /// User Sign-Up
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/sign-up',
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
          'fullName': name,
          'role': role,
        },
      );

      final newToken = response.data['token'] as String;
      await ShPService.saveToken(newToken);

      Logger().i(response.data);
      return response.data;
    } on DioException catch (e) {
      return {
        'error': e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        'status': e.response?.statusCode ?? 500,
      };
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// User Log-In
  Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      final newToken = response.data['token'] as String;
      await ShPService.saveToken(newToken);

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
      throw Exception('Login davomida xatolik yuz berdi.');
    }
  }

  /// Rate the stadium
  Future<Response> rateTheStadium(int stadiumId, int rating) async {
    try {
      return await _dio.post(
        '/stadium/$stadiumId/rate',
        queryParameters: {'rating': rating},
      );
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        data: {
          'error': e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        },
      );
    }
  }

  /// Create stadium
  Future<Response> createStadium({required Map<String, Object?> body}) async {
    try {
      final response = await _dio.post('/stadium/create', data: body);
      Logger().i(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final stadiumId = response.data['id'] as int;
        await ShPService.saveOwnerStadiumId(stadiumId);
      }

      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        data: {
          'error': e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        },
      );
    }
  }

  /// Get all stadiums with size
  Future<List<StadiumDetail>> getAllStadiumsWithSize({required int size}) async {
    try {
      final response = await _dio.get('/stadium/all/info', queryParameters: {'size': size});
      final rawList = response.data;

      if (rawList == null || rawList is! List) {
        throw Exception("Invalid response format");
      }

      return rawList
          .whereType<Map<String, dynamic>>()
          .map((item) {
        try {
          return StadiumDetail.fromJson(item);
        } catch (_) {
          return null;
        }
      })
          .whereType<StadiumDetail>()
          .toList();
    } catch (e) {
      throw Exception('Error fetching stadiums: $e');
    }
  }

  /// Get all stadiums
  Future<List<StadiumDetail>> getAllStadiums() async {
    try {
      final response = await _dio.get('/stadium/all/info');
      final rawList = response.data;

      if (rawList == null || rawList is! List) {
        throw Exception("Invalid response format");
      }

      return rawList
          .whereType<Map<String, dynamic>>()
          .map((item) {
        try {
          return StadiumDetail.fromJson(item);
        } catch (_) {
          return null;
        }
      })
          .whereType<StadiumDetail>()
          .toList();
    } catch (e) {
      throw Exception('Error fetching stadiums: $e');
    }
  }

  /// Get stadium by ID
  Future<StadiumDetail> getStadiumById({required int stadiumId}) async {
    try {
      final response = await _dio.get('/stadium/$stadiumId/info');
      final data = response.data;

      if (data == null || data is! Map<String, dynamic>) {
        throw Exception("Invalid stadium data");
      }

      return StadiumDetail.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching stadium details: $e');
    }
  }

  /// Get stadium info by token
  Future<StadiumDetail> getStadiumByToken() async {
    try {
      final response = await _dio.get('/stadium/info');
      final data = response.data;

      if (data == null || data is! Map<String, dynamic>) {
        throw Exception("Invalid stadium data");
      }

      return StadiumDetail.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching stadium details: $e');
    }
  }



  Future<UserModel> getUser() async {
    try {
      final response = await _dio.get('/user/info');
      return UserModel.fromJson(response.data);
    } on DioException {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }


  Future<List<SubscriptionModel>> getOwnerSubscription() async {
    try {
      final response = await _dio.get('/subscriptions/owner');
      List list = response.data;
      return list.map((json) => SubscriptionModel.fromJson(json)).toList();
    } on DioException {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }


  Future<List<SubscriptionModel>> getClientSubscription() async {
    try {
      final response = await _dio.get('/subscriptions/client');
      List list = response.data;
      return list.map((json) => SubscriptionModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  Future<List<BankCard>> getUserDonation() async {
    try {
      final response = await _dio.get('/donation/cards');
      List list = response.data;
      return list.map((json) => BankCard.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  Future<ChatModel> getChatFromApi(int chatId) async {
    try {
      final response = await _dio.get('/chat/$chatId/get');
      return ChatModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Chat ma'lumotlarini olishda xatolik: ${e.message}");
    }
  }

  Future<List<Tournament>> getTournaments() async {
    try {
      final response = await _dio.get('/tournament/all');

      List data = response.data;
      return data.map((json) => Tournament.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Turnir ma'lumotlarini olishda xatolik!");
    }
  }

  Future<List<Substadiums>> getBronList({required int size}) async {
    try {
      final response = await _dio.get('/stadium/bookings', queryParameters: {
        "page": size,
      });

      if (response.statusCode == 200) {
        if (response.data != null && response.data['fields'] != null) {
          List<Substadiums> substadiumsList = (response.data['fields'] as List)
              .map((e) => Substadiums.fromJson(e))
              .toList();
          return substadiumsList;
        } else {
          throw Exception(
              "API javobi noto'g'ri formatda yoki 'fields' maydoni yo'q.");
        }
      } else if (response.statusCode == 403) {
        // Возвращаем пустой список при 403
        return [];
      } else {
        throw Exception("API so'rovi muvaffaqiyatsiz: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 403) {
          Logger().e(
              "403: Foydalanuvchiga ruxsat yo'q, bo‘sh ro‘yxat qaytariladi.");
          return [];
        }
        throw Exception(
            "API so'rovi xatosi: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        throw Exception("Tarmoq xatosi: ${e.message}");
      }
    } catch (e) {
      throw Exception("Bronlarni olishda xatolik: ${e.toString()}");
    }
  }

  Future<Substadiums> getSubStadiumBooks({required int subStadiumId}) async {
    try {
      final response = await _dio.get('/stadium/field/$subStadiumId/info');

      if (response.statusCode == 200) {
        if (response.data != null && response.data['fields'] != null) {
          return Substadiums.fromJson(response.data);
        } else {
          throw Exception(
              "API javobi noto'g'ri formatda yoki 'fields' maydoni yo'q.");
        }
      } else {
        throw Exception("API so'rovi muvaffaqiyatsiz: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            "API so'rovi xatosi: ${e.response?.statusCode} - ${e.response?.data}");
      } else {
        throw Exception("Tarmoq xatosi: ${e.message}");
      }
    } catch (e) {
      throw Exception("Bronlarni olishda xatolik: ${e.toString()}");
    }
  }

  Future<Tournament> voteForTournaments(int tournamentId) async {
    try {
      final response = await _dio.post('/tournament/$tournamentId/add');

      // Agar API bitta tournament obyektini qaytarsa, to'g'ri ishlaydi
      return Tournament.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Ovoz berishda xatolik!");
    }
  }

  Future<void> addStadiumImages(int stadiumId, List<XFile> images) async {
    try {
      FormData formData = FormData();

      for (int i = 0; i < images.length; i++) {
        formData.files.add(MapEntry(
          'files', // Serverda rasmlar qabul qilinadigan maydon nomi
          await MultipartFile.fromFile(images[i].path, filename: 'image$i.jpg'),
        ));
      }

      final response =
          await _dio.post('/stadium/$stadiumId/add-image', data: formData);

      if (response.statusCode == 200) {
        print('Rasmlar muvaffaqiyatli yuklandi');
      } else {
        throw Exception('Rasmlarni yuklashda xatolik: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Tarmoq xatosi: ${e.message}');
    } catch (e) {
      throw Exception('Rasmlarni yuklashda xatolik: ${e.toString()}');
    }
  }

  Future<UserModel> updateUserInfo({required String name}) async {
    try {
      final response = await _dio.post('/user/update', data: {
        "fullName": name,
      });
      return UserModel.fromJson(response.data);
    } on DioException {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }


  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      Response response = await _dio.post(
        "/user/img/update",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Image upload failed");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }


  //getAllUsers
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _dio.get('/user/all/info');

      List<dynamic> jsonList = response.data; // JSON list
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchilar ma'lumotlarini olishda xatolik!");
    }
  }

  //getFriends
  Future<List<Friendship>> getFriends() async {
    try {
      final response = await _dio.get('/friendship/get');

      List jsonList = response.data as List;
      return jsonList
          .map((json) => Friendship.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Foydalanuvchilar ma'lumotlarini olishda xatolik!");
    }
  } //getFriends

  Future<List<QuizPack>> getQuizWithPacks() async {
    try {
      final response = await _dio.get('/pack/all/get');

      List jsonList = response.data as List;
      return jsonList
          .map((json) => QuizPack.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception("Quiz ma'lumotlarini olishda xatolik!");
    }
  }

  Future<QuizPack> getQuizPack({required int quizPackId}) async {
    try {
      final response = await _dio.get('/pack/$quizPackId/get');

      return QuizPack.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception("Quiz ma'lumotlarini olishda xatolik!");
    }
  }

  Future removeFromClub({required int clubId, required memberId}) async {
    try {
      final response = await _dio.delete('/club/$clubId/members/remove', data: {
        "membersId": [memberId]
      });

      return response.data;
    } on DioException catch (e) {
      throw Exception("Quiz ma'lumotlarini olishda xatolik!");
    }
  }

  Future<List<UserPoints>> getLiderBoard({required int limit}) async {
    try {
      final response = await _dio.get(
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

  //Add to friends
  Future addToFriends({required int userId}) async {
    try {
      final response = await _dio
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

  //Remove friends
  Future removeFromFriends({required int userId}) async {
    try {
      final response = await _dio.delete("/friendship/$userId/remove");

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      } else {
        throw Exception('Fav davomida xatolik yuz berdi: ${e.toString()}');
      }
    }
  }

  //find user
  Future findUserByNumber({required int number}) async {
    try {
      final response = await _dio.get("/user/find", queryParameters: {
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

  //Add to favourites
  Future<void> addToFav({required int stadiumId}) async {
    try {
      await _dio
          .post("/user/favourites", queryParameters: {'stadiumId': stadiumId});
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  //createClub
  Future<void> createClub({required String name, required int memberId}) async {
    try {
      await _dio.post("/club/create", data: {
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

  //getClubInfo
  Future<void> getClubInfo(
      {required String name, required int memberId}) async {
    try {
      await _dio.post("/club/2/info", data: {
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

  Future<void> removeFromFav({required int stadiumId}) async {
    try {
      final response = await _dio.delete("/user/favourites/$stadiumId/remove");
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
      final response = await _dio.get('/user/favourites');

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

  //book a stadium
  Future bookStadium({
    required int subStadiumId,
    required List<TimeSlot> bookings,
  }) async {
    try {
      final response = await _dio.post(
        "/stadium/$subStadiumId/book",
        data: bookings.map((slot) => slot.toJson()).toList(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }

      throw Exception('Book xatolik yuz berdi.');
    }
  }
}
