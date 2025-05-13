import 'package:dio/dio.dart';

import '../../constants/config.dart';
import '../shared_preference_service.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(BaseOptions(
    baseUrl: Config.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  )) {
    dio.interceptors.add(InterceptorsWrapper(
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
    ));
  }
}
