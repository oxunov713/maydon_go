import 'package:dio/dio.dart';

import '../../model/stadium_model.dart';
import '../../model/substadium_model.dart';
import '../../model/time_slot_model.dart';
import '../shared_preference_service.dart';

class StadiumService {
  final Dio dio;

  const StadiumService(this.dio);

  /// Rate the stadium
  Future<Response> rateTheStadium(int stadiumId, int rating) async {
    try {
      return await dio.post(
        '/stadium/$stadiumId/rate',
        queryParameters: {'rating': rating},
      );
    } on DioException catch (e) {
      return Response(
        requestOptions: e.requestOptions,
        statusCode: e.response?.statusCode ?? 500,
        data: {
          'error':
              e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        },
      );
    }
  }

  /// Create stadium
  Future<Response> createStadium({required Map<String, Object?> body}) async {
    try {
      final response = await dio.post('/stadium/create', data: body);

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
          'error':
              e.response?.data ?? {'message': e.message ?? 'Unknown error'},
        },
      );
    }
  }

  /// Get all stadiums with size
  Future<List<StadiumDetail>> getAllStadiumsWithSize(
      {required int size}) async {
    try {
      final response =
          await dio.get('/stadium/all/info', queryParameters: {'size': size});
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
      final response = await dio.get('/stadium/all/info');
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
      final response = await dio.get('/stadium/$stadiumId/info');
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
      final response = await dio.get('/stadium/info');
      final data = response.data;

      if (data == null || data is! Map<String, dynamic>) {
        throw Exception("Invalid stadium data");
      }

      return StadiumDetail.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching stadium details: $e');
    }
  }
  Future<List<Substadiums>> getBronList({required int size}) async {
    try {
      final response = await dio.get('/stadium/bookings', queryParameters: {
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
      final response = await dio.get('/stadium/field/$subStadiumId/info');

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
  } //book a stadium
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
