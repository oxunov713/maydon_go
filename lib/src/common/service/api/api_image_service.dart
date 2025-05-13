import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class ApiImageService {
  final Dio dio;

  ApiImageService(this.dio);

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
      await dio.post('/stadium/$stadiumId/add-image', data: formData);

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
  } Future<String> uploadProfileImage(File imageFile) async {
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
}
