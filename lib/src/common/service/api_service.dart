import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/main_model.dart';

import '../constants/config.dart';
import '../model/stadium_model.dart';
import 'shared_preference_service.dart';

class ApiService {
  final logger = Logger();
  late Dio dio;
  static String? token;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl, // Backend API manzili
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    // Interceptor qo'shish
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          token = await ShPService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            logger.w("Tokeni muddati tugadi");
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
      token = newToken;
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
      token = newToken; // Runtime saqlash
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

  // Get all stadium
  Future<List<StadiumDetail>> getAllStadiums({required int size}) async {
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
      logger.w(response.data);
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
      final response = await dio.get('/friend/get');
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
    try {
      final response = await dio.post(
        "/friend/add",
        data: jsonEncode([userId]),
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
