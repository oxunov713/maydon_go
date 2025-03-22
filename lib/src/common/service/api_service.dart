import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/main_model.dart';
import 'package:maydon_go/src/common/model/time_slot_model.dart';

import '../constants/config.dart';
import '../model/stadium_model.dart';
import 'shared_preference_service.dart';

class ApiService {
  final logger = Logger();
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
            // Token yaroqsiz bo'lsa, foydalanuvchini logout qilish
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
      logger.e(role);
      logger.d('Signup Token: $newToken');
      return response.data;
    } on DioException catch (e) {
      logger.e('Error Message: ${e.message}');

      return {
        'error': e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        'status': e.response?.statusCode ?? 500,
      };
    } catch (e) {
      logger.e('Unknown error:+++ $e');
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

      logger.i("Login Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        logger.w("Login Error Response: ${e.response?.data}");
        return e.response?.data;
      }
      logger.e("Login Error: $e");
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
      logger.e('Error Message: ${e.message}');

      return {
        'error': e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        'status': e.response?.statusCode ?? 500,
      };
    } catch (e) {
      logger.e('Unknown error:+++ $e');
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

      // Log the API response to debug its structure
      logger.d("API Response: ${response.data}");

      // Handle null response
      if (response.data == null) {
        throw Exception("API response is null");
      }

      // Ensure response.data is a list
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
              logger.e("Error parsing stadium data: $e, Data: $item");
              return null; // Skip invalid items
            }
          })
          .whereType<StadiumDetail>() // Remove null values
          .toList();

      return stadiums;
    } catch (e) {
      logger.e("Error fetching stadiums: $e");
      throw Exception('Error fetching stadiums: $e');
    }
  }

  //Get all stadiums
  Future<List<StadiumDetail>> getAllStadiums() async {
    try {
      final response = await dio.get('/stadium/all/info');

      // Log the API response to debug its structure
      logger.d("API Response: ${response.data}");

      // Handle null response
      if (response.data == null) {
        throw Exception("API response is null");
      }

      // Ensure response.data is a list
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
              logger.e("Error parsing stadium data: $e, Data: $item");
              return null; // Skip invalid items
            }
          })
          .whereType<StadiumDetail>() // Remove null values
          .toList();

      return stadiums;
    } catch (e) {
      logger.e("Error fetching stadiums: $e");
      throw Exception('Error fetching stadiums: $e');
    }
  }

  // Get stadium by ID
  Future<StadiumDetail> getStadiumById({required int stadiumId}) async {
    try {
      final response = await dio.get('/stadium/$stadiumId/info');

      // Log the API response to debug its structure
      logger.d("API Response for stadium \$stadiumId: \${response.data}");

      // Handle null response
      if (response.data == null) {
        throw Exception("API response is null");
      }

      // Ensure response.data is a valid Map
      if (response.data is! Map<String, dynamic>) {
        throw Exception("Expected a Map but got \${response.data.runtimeType}");
      }

      try {
        return StadiumDetail.fromJson(response.data);
      } catch (e) {
        logger.e("Error parsing stadium data: \$e, Data: \${response.data}");
        throw Exception("Error parsing stadium data");
      }
    } catch (e) {
      logger.e("Error fetching stadium details: \$e");
      throw Exception('Error fetching stadium details: \$e');
    }
  }

  //Get userinfo
  Future<UserModel> getUser() async {
    try {
      final response = await dio.get('/user/info');
      logger.e(response.data);
      logger.w("Userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      logger.e("❌ Xatolik yuz berdi: ${e.response?.data ?? e.message}");
      throw Exception("Foydalanuvchi ma'lumotlarini olishda xatolik!");
    }
  }

  //getAllUsers
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await dio.get('/user/all/info');
      logger.w(response.data);

      List<dynamic> jsonList = response.data; // JSON list
      return jsonList
          .map((json) => UserModel.fromJson(json))
          .toList(); // List<UserModel> ga o‘giramiz
    } on DioException catch (e) {
      logger.e("❌ Xatolik yuz berdi: ${e.response?.data ?? e.message}");
      throw Exception("Foydalanuvchilar ma'lumotlarini olishda xatolik!");
    }
  }

  //getFriends
  Future<List<UserModel>> getFriends() async {
    try {
      final response = await dio.get('/friendship/get');
      logger.w(response.data);

      List jsonList = response.data; // JSON list
      return jsonList
          .map((json) => UserModel.fromJson(json))
          .toList(); // List<UserModel> ga o‘giramiz
    } on DioException catch (e) {
      logger.e("❌ Xatolik yuz berdi: ${e.response?.data ?? e.message}");
      throw Exception("Foydalanuvchilar ma'lumotlarini olishda xatolik!");
    }
  }

  //Add to friends
  Future addToFriends({required int userId}) async {
    List<int> user = [userId];

    try {
      final response = await dio.post(
        "/friend/add",
        data: jsonEncode(user), // JSON formatga o'tkazish
      );

      logger.i("✅ Add to Friends Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e("⛔ Add fav Error Status: ${e.response?.statusCode}");
        logger.e("⛔ Add fav Error Response: ${e.response?.data}");
        return e.response?.data;
      } else {
        logger.e("⛔ DioException: ${e.toString()}");
        throw Exception('Fav davomida xatolik yuz berdi: ${e.toString()}');
      }
    }
  }

  //find user
  Future findUserByNumber({required int number}) async {
    try {
      final response = await dio.post(
        "/user/find/$number",
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        logger.w("Add fav Error Response: ${e.response?.data}");
        return e.response?.data;
      }
      logger.e("Add fav Error: $e");
      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  //Add to favourites
  Future addToFav({required int stadiumId}) async {
    try {
      final response = await dio.post(
        "/user/favourites",
        data: [stadiumId],
      );

      logger.i("Add to Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        logger.w("Add fav Error Response: ${e.response?.data}");
        return e.response?.data;
      }
      logger.e("Add fav Error: $e");
      throw Exception('fav davomida xatolik yuz berdi.');
    }
  }

  //book a stadium
  Future bookStadium({
    required int subStadiumId,
    required List<TimeSlot> bookings,
  }) async {
    print("bookStadium ishladi ✅"); // 🔥 Shu chiqyaptimi?
    try {
      final response = await dio.post(
        "/stadium/$subStadiumId/book",
        data: bookings.map((slot) => slot.toJson()).toList(),
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      print("API javobi: ${response.data} ✅"); // 🔥 Shu chiqyaptimi?
      logger.d("Success ${response.data}");
      return response.data;
    } on DioException catch (e) {
      print("DioException bo‘ldi ❌"); // 🔥 Shu chiqyaptimi?
      if (e.response != null) {
        print("Server javobi: ${e.response?.data} ❌"); // 🔥 Shu chiqyaptimi?
        logger.e("Book error: ${e.response?.data}");
        return e.response?.data;
      }
      logger.e("Book Error: $e");
      throw Exception('Book xatolik yuz berdi.');
    }
  }

  //Get favourites
  Future<List<StadiumDetail>> getFavourites({required int size}) async {
    try {
      final response = await dio.get('/user/favourites');

      // Log the API response to debug its structure
      logger.d("API Response: ${response.data}");

      // Handle null response
      if (response.data == null) {
        throw Exception("API response is null");
      }

      // Ensure response.data is a list
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
              logger.e("Error parsing stadium data: $e, Data: $item");
              return null; // Skip invalid items
            }
          })
          .whereType<StadiumDetail>() // Remove null values
          .toList();

      return stadiums;
    } catch (e) {
      logger.e("Error fetching stadiums: $e");
      throw Exception('Error fetching stadiums: $e');
    }
  }
}
