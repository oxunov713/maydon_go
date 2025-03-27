import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/friend_model.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/model/time_slot_model.dart';
import 'package:maydon_go/src/common/model/tournament_model.dart';

import '../constants/config.dart';
import '../model/points_model.dart';
import '../model/stadium_model.dart';
import 'shared_preference_service.dart';

class ApiService {
  final Dio dio;

  ApiService()
      : dio = Dio(
          BaseOptions(
            baseUrl: Config.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await ShPService.getToken();
          if (token != null) {
            options.headers['Authorization'] =
                'Bearer $token'; // Tokenni header ga qo'shish
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

// User SignUp
  Future signUp({
    required String name,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    try {
      final response = await dio.post(
        "/auth/sign-up",
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
          'fullName': name,
          'role': role,
        },
      );

      final String newToken = response.data['token'];

      await ShPService.saveToken(newToken);

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

//User LogIn
  Future login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        "/auth/login",
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      final String newToken = response.data['token']; // Tokenni javobdan olish

      await ShPService.saveToken(newToken); // Local saqlash

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data;
      }
      throw Exception('Login davomida xatolik yuz berdi.');
    }
  }

  //Rate the stadium
  Future rateTheStadium(int stadiumId, int rating) async {
    try {
      final response =
          await dio.get('/stadium/$stadiumId/rate', queryParameters: {
        'rating': rating,
      });

      return response;
    } on DioException catch (e) {
      return {
        'error': e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        'status': e.response?.statusCode ?? 500,
      };
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  // Get all stadiums with size
  Future<List<StadiumDetail>> getAllStadiumsWithSize(
      {required int size}) async {
    try {
      final response = await dio.get('/stadium/all/info', queryParameters: {
        'size': size,
      });

      if (response.data == null) {
        throw Exception("API response is null");
      }

      if (response.data is! List) {
        throw Exception("Expected a list but got ${response.data.runtimeType}");
      }

      final List<dynamic> rawList = response.data;

      final List<StadiumDetail> stadiums = rawList
          .whereType<Map<String, dynamic>>() // Only process valid maps
          .map((item) {
            try {
              return StadiumDetail.fromJson(item);
            } catch (e) {
              return null; // Skip invalid items
            }
          })
          .whereType<StadiumDetail>() // Remove null values
          .toList();

      return stadiums;
    } catch (e) {
      throw Exception('Error fetching stadiums: $e');
    }
  }

  //Get all stadiums
  Future<List<StadiumDetail>> getAllStadiums() async {
    try {
      final response = await dio.get('/stadium/all/info');

      if (response.data == null) {
        throw Exception("API response is null");
      }

      if (response.data is! List) {
        throw Exception("Expected a list but got ${response.data.runtimeType}");
      }

      final List<dynamic> rawList = response.data;

      final List<StadiumDetail> stadiums = rawList
          .whereType<Map<String, dynamic>>() // Only process valid maps
          .map((item) {
            try {
              return StadiumDetail.fromJson(item);
            } catch (e) {
              return null; // Skip invalid items
            }
          })
          .whereType<StadiumDetail>() // Remove null values
          .toList();

      return stadiums;
    } catch (e) {
      throw Exception('Error fetching stadiums: $e');
    }
  }

  // Get stadium by ID
  Future<StadiumDetail> getStadiumById({required int stadiumId}) async {
    try {
      final response = await dio.get('/stadium/$stadiumId/info');

      if (response.data == null) {
        throw Exception("API response is null");
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception("Expected a Map but got \${response.data.runtimeType}");
      }

      try {
        return StadiumDetail.fromJson(response.data);
      } catch (e) {
        throw Exception("Error parsing stadium data");
      }
    } catch (e) {
      throw Exception('Error fetching stadium details: \$e');
    }
  }

  //Get userinfo
  Future<UserModel> getUser() async {
    try {
      final response = await dio.get('/user/info');

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  Future<List<Tournament>> getTournaments() async {
    try {
      final response = await dio.get('/tournament/all');


      List<dynamic> data = response.data;
      return data.map((json) => Tournament.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception("Turnir ma'lumotlarini olishda xatolik!");
    }
  }

  Future<Tournament> voteForTournaments(int tournamentId) async {
    try {
      final response = await dio.post('/tournament/$tournamentId/add');

      // Agar API bitta tournament obyektini qaytarsa, to'g'ri ishlaydi
      return Tournament.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Ovoz berishda xatolik!");
    }
  }


  //Get userinfo
  Future<UserModel> updateUserInfo({required String name}) async {
    try {
      final response = await dio.post('/user/update', data: {
        "fullName": name,
      });

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  } //Get userinfo

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file":
            await MultipartFile.fromFile(imageFile.path, filename: fileName),
      });

      Response response = await dio.post(
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
      final response = await dio.get('/user/all/info');

      List<dynamic> jsonList = response.data; // JSON list
      return jsonList
          .map((json) => UserModel.fromJson(json))
          .toList(); // List<UserModel> ga o‘giramiz
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

  //Add to friends
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

  //find user
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

  //createClub
  Future<void> createClub({required String name, required int memberId}) async {
    try {
      await dio.post("/club/create", data: {
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



  //book a stadium
  Future bookStadium({
    required int subStadiumId,
    required List<TimeSlot> bookings,
  }) async {
    try {
      final response = await dio.post(
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
