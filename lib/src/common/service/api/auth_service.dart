import 'package:dio/dio.dart';

import '../shared_preference_service.dart';

class AuthService{
  final Dio dio;

  AuthService(this.dio);

  /// User Sign-Up
  Future<Map<String, dynamic>> signUp({
    required String name,
    required String phoneNumber,
    required String password,
    required String role,
  }) async {
    try {
      final response = await dio.post(
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
      final response = await dio.post(
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
}