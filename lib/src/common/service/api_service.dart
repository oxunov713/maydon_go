import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../constants/config.dart';
import '../model/stadium_model.dart';
import 'shared_preference_service.dart';

class ApiService {
  final logger = Logger();
  late Dio dio;
  static String? token; // Tokenni saqlash

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: Config.baseUrl, // Backend API manzili
        connectTimeout: const Duration(seconds: 100),
        receiveTimeout: const Duration(seconds: 100),
      ),
    );

    // Interceptor qo'shish
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Tokenni har bir so'rovga qo'shish
        token = await ShPService
            .getToken(); // Ensure token is fetched from local storage
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options); // So'rovni davom ettirish
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Agar 401 qaytsa, token muddati tugagan
        }
        return handler.next(error);
      },
    ));
  }

  // User SignUp
  Future userSignUp({
    required String name,
    required String phoneNumber,
    required String password,
    required String language,
  }) async {
    try {
      final response = await dio.post(
        "/auth/sign-up",
        queryParameters: {'lang': language},
        data: {
          'phoneNumber': phoneNumber,
          'password': password,
          'role': "CLIENT",
        },
      );

      final String newToken = response.data['token']; // Tokenni javobdan olish
      token = newToken; // Runtime saqlash
      await ShPService.saveToken(newToken); // Local saqlash

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
  Future userLogin({
    required String phoneNumber,
    required String password,
    required String language,
  }) async {
    try {
      final response = await dio.post(
        "/auth/login",
        queryParameters: {'lang': language},
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

      // Ensure the data is a list of maps before converting it
      if (response.data is List) {
        return (response.data as List)
            .map((stadiumJson) {
              try {
                return StadiumDetail.fromJson(stadiumJson as Map<String, Object?>);
              } catch (e) {
                logger.e("Error parsing stadium data: $e");
                return null; // Skip this stadium if parsing fails
              }
            })
            .where((stadium) => stadium != null)
            .toList() as List<StadiumDetail>; // Filter out null values
      } else {
        throw Exception("Expected a list of stadiums but got something else.");
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Error fetching stadiums: $e');
    }
  }
}
