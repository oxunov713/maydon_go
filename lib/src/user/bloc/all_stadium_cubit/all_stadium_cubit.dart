import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:maydon_go/src/common/model/stadium_model.dart';
import '../../../common/constants/config.dart';
import 'all_stadium_state.dart';

class StadiumCubit extends Cubit<StadiumState> {
  final TextEditingController searchController = TextEditingController();
  late DateTime currentDate;
  late List<CarouselSliderController>? carouselControllers;

  StadiumCubit() : super(StadiumInitial()) {
    currentDate = DateTime.now();
    fetchStadiums();
  }

  /// **Stadionlarni yuklash**
  Future<void> fetchStadiums() async {
    emit(StadiumLoading());

    try {
      final List<StadiumDetail> stadiums = $fakeData;
      carouselControllers =
          List.generate(stadiums.length, (_) => CarouselSliderController());

      emit(StadiumLoaded(
        stadiums: stadiums,
        filteredStadiums: stadiums,
        currentIndexList: List.filled(stadiums.length, 0),
        isSearching: false,
      ));
    } catch (e) {
      emit(StadiumError('Xatolik: ${e.toString()}'));
    }
  }

  /// **Stadionlarni qidirish**
  void filterStadiums(String query) {
    final currentState = state;
    if (currentState is StadiumLoaded) {
      final filteredList = query.isEmpty
          ? currentState.stadiums
          : currentState.stadiums
              .where((stadium) =>
                  stadium.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

      emit(currentState.copyWith(
        filteredStadiums: filteredList,
        isSearching: query.isNotEmpty,
      ));
    }
  }

  /// **Qidiruv rejimini yoqish/o‘chirish**
  void toggleSearchMode() {
    final currentState = state;
    if (currentState is StadiumLoaded) {
      final bool isSearching = !currentState.isSearching;
      emit(currentState.copyWith(
        filteredStadiums:
            isSearching ? currentState.filteredStadiums : currentState.stadiums,
        isSearching: isSearching,
      ));
      if (!isSearching) searchController.clear();
    }
  }

  /// **Karusel indeksini yangilash**
  void updateCurrentIndex(int index, int stadiumIndex) {
    final currentState = state;
    if (currentState is StadiumLoaded) {
      final updatedIndexList = List<int>.from(currentState.currentIndexList);
      updatedIndexList[stadiumIndex] = index;

      emit(currentState.copyWith(currentIndexList: updatedIndexList));
    }
  }

  /// **Tanlangan sanani yangilash**
  void changeDate(DateTime newDate) {
    currentDate = newDate;
    final currentState = state;
    if (currentState is StadiumLoaded) {
      emit(currentState.copyWith());
    }
  }

  CarouselSliderController getCarouselController(int stadiumIndex) {
    return carouselControllers![stadiumIndex];
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
