import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/model/stadium_model.dart';

import '../../../common/service/api_service.dart';
import 'all_stadium_state.dart';

class StadiumCubit extends Cubit<StadiumState> {
  late DateTime currentDate;
  late List<CarouselSliderController> carouselControllers;
  final TextEditingController searchController = TextEditingController();
  List<StadiumDetail> stadiums = [];
  List<StadiumDetail> filteredStadiums = [];

  StadiumCubit() : super(StadiumInitial()) {
    currentDate = DateTime.now();
    fetchStadiums();
  }

  Future<void> fetchStadiums() async {
    emit(StadiumLoading());

    try {
      final List<StadiumDetail> fetchedStadiums =
          await ApiService().getAllStadiums();

      stadiums = fetchedStadiums;
      filteredStadiums = List.from(stadiums);

      carouselControllers =
          List.generate(stadiums.length, (_) => CarouselSliderController());

      emit(StadiumLoaded(
        stadiums: stadiums,
        filteredStadiums: filteredStadiums,
        currentIndexList: List.filled(stadiums.length, 0),
        isSearching: false,
      ));
    } catch (e) {
      emit(StadiumError('Xatolik: ${e.toString()}'));
    }
  }

  void filterStadiums(String query) {
    if (state is StadiumLoaded) {
      final currentState = state as StadiumLoaded;

      // 🔹 filter qilishdan oldin stadiums ro‘yxatini yangilaymiz
      filteredStadiums = stadiums
          .where((stadium) =>
          stadium.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(currentState.copyWith(filteredStadiums: filteredStadiums));
    }
  }

  void toggleSearchMode() {
    if (state is StadiumLoaded) {
      final currentState = state as StadiumLoaded;
      if (currentState.isSearching) {
        // 🔹 Search yopilganda filteredStadiums ni asl stadiums listiga qaytaramiz
        emit(currentState.copyWith(
          isSearching: false,
          filteredStadiums: stadiums,
        ));
      } else {
        emit(currentState.copyWith(isSearching: true));
      }
    }
  }

  void updateCurrentIndex(int index, int stadiumIndex) {
    if (state is StadiumLoaded) {
      final currentState = state as StadiumLoaded;
      final updatedIndexList = List<int>.from(currentState.currentIndexList);
      updatedIndexList[stadiumIndex] = index;
      emit(currentState.copyWith(currentIndexList: updatedIndexList));
    }
  }

  CarouselSliderController getCarouselController(int stadiumIndex) {
    return carouselControllers[stadiumIndex];
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
