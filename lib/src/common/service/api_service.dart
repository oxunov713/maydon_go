import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

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
        connectTimeout: const Duration(seconds: 100),
        receiveTimeout: const Duration(seconds: 100),
      ),
    );

    // Interceptor qo'shish
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Tokenni har bir so'rovga qo'shish
          token = await ShPService
              .getToken(); // Ensure token is fetched from local storage
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
      logger.e('Error: ${e.response?.data ?? e.message}');
      return e.response?.data ?? {'error': e.message};
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


}
