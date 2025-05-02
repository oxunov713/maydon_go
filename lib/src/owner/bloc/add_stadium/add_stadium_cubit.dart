import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/model/stadium_model.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';
import '../../../common/service/api_service.dart';
import 'add_stadium_state.dart';

class AddStadiumCubit extends Cubit<AddStadiumState> {
  final Logger _logger = Logger();
  int size = 10;
  bool hasMoreData = true;

  AddStadiumCubit() : super(AddStadiumState.initial());

  void updateName(String name) => emit(
      state.copyWith(name: name, errorMessage: null, isFormSubmitted: false));

  void updateDescription(String description) => emit(state.copyWith(
      description: description, errorMessage: null, isFormSubmitted: false));

  void updatePrice(String price) => emit(
      state.copyWith(price: price, errorMessage: null, isFormSubmitted: false));

  void updateCount(String count) {
    final parsedCount = int.tryParse(count) ?? 0;
    emit(state.copyWith(
        count: parsedCount, errorMessage: null, isFormSubmitted: false));
  }

  void toggleHasUniforms() => emit(
      state.copyWith(hasUniforms: !state.hasUniforms, isFormSubmitted: false));

  void toggleHasBathroom() => emit(
      state.copyWith(hasBathroom: !state.hasBathroom, isFormSubmitted: false));

  void toggleIsIndoor() =>
      emit(state.copyWith(isIndoor: !state.isIndoor, isFormSubmitted: false));

  void updateLocation(Map<String, dynamic> locationData) {
    emit(state.copyWith(
      locationData: locationData,
      latitude: locationData['latitude'],
      longitude: locationData['longitude'],
      errorMessage: null,
      isFormSubmitted: false,
    ));
  }

  Future<void> submitStadium() async {
    emit(state.copyWith(isFormSubmitted: true));

    if (!_validateInputs()) return;

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final timeSlot = {
        "startTime": "00:00:00",
        "endTime": "23:59:59",
      };

      // Generate a list of field objects based on the count
      final List<Map<String, String>> fields = List.generate(
        state.count,
            (index) => {"name": "${state.name} Maydon ${index + 1}"}, // You can customize the name here
      );

      final stadiumData = {
        "name": state.name,
        "description": state.description,
        "price": int.parse(state.price),
        "location": {
          "country": state.locationData['country'] ?? '',
          "city": state.locationData['city'] ?? '',
          "street": state.locationData['street'] ?? '',
          "address": state.locationData['address'] ?? '',
          "latitude": state.latitude,
          "longitude": state.longitude,
        },
        "facilities": {
          "hasBathroom": state.hasBathroom,
          "isIndoor": state.isIndoor,
          "hasUniforms": state.hasUniforms,
        },
        "timeSlot": timeSlot,
        "fields": fields, // Use the dynamically generated list of fields
      };

      await ApiService().createStadium(body: stadiumData);
      _logger.i('Stadium created with ${fields.length} fields: $stadiumData');
      Future.delayed(Duration(seconds: 3));
      emit(state.copyWith(isSuccess: true, isSubmitting: false));
      await loadSubstadiums(isRefresh: true); // Refresh the list after adding
    } catch (e) {
      _logger.e('Failed to create stadium with multiple fields: $e');
      emit(state.copyWith(
        errorMessage: 'Failed to create stadium: ${e.toString()}',
        isSubmitting: false,
      ));
    }
  }

  bool _validateInputs() {
    if (!state.isFormSubmitted) return true;

    if (state.name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter stadium name'));
      return false;
    }
    if (state.description.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter description'));
      return false;
    }
    if (state.price.isEmpty || int.tryParse(state.price) == null) {
      emit(state.copyWith(errorMessage: 'Please enter valid price'));
      return false;
    }
    if (state.count <= 0) {
      emit(state.copyWith(errorMessage: 'Please enter valid stadium count'));
      return false;
    }
    if (state.latitude == null || state.longitude == null) {
      emit(state.copyWith(errorMessage: 'Please select location'));
      return false;
    }
    return true;
  }

  Future<void> loadSubstadiums({bool isRefresh = false}) async {
    if (state.isLoading && !isRefresh) return; // Не загружать, если уже загружается и не обновление

    try {
      if (isRefresh) {
        size = 10;
        hasMoreData = true;
        emit(state.copyWith(substadiums: [], isLoading: true, hasError: false)); // Очищаем список и начинаем загрузку
      } else {
        emit(state.copyWith(isLoading: true, hasError: false)); // Начинаем загрузку, но не очищаем список
      }

      final substadiums = await ApiService().getBronList(size: size);
      _logger.i("Yuklangan substadionlar: ${substadiums.length}");

      if (substadiums.isEmpty) {
        hasMoreData = false;
        emit(state.copyWith(isLoading: false)); // Завершаем загрузку, если нет данных
        return;
      }

      size += 10;

      emit(state.copyWith(
        substadiums: substadiums, // Заменяем список, если обновление, или добавляем, если нет
        isLoading: false,
        isSuccess: false,
      ));
    } catch (e) {
      _logger.e('Failed to load substadiums: $e');
      emit(state.copyWith(
          isLoading: false, hasError: true, errorMessage: e.toString()));
    }
  }

  Future<void> getFieldBookings({required int fieldId}) async {
    try {
      emit(state.copyWith(hasError: false, isLoading: true));
      final substadium =
          await ApiService().getSubStadiumBooks(subStadiumId: fieldId);
      emit(state.copyWith(
          isLoading: false, hasError: false, substadium: substadium));
    } catch (e) {
      _logger.e('Failed to load substadiums: $e');
      emit(state.copyWith(
          isLoading: false, hasError: true, errorMessage: e.toString()));
    }
  }

  Future<int> getCurrentStadium() async {
    StadiumDetail stadium = StadiumDetail(name: "No name", id: -1);
    try {
      stadium = await ApiService().getStadiumByToken();
    } catch (e) {
      _logger.e('Failed to load current stadium: $e');
    }
    return stadium.id ?? -1;
  }
}
