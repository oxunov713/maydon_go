import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/common/model/stadium_model.dart';
import 'package:maydon_go/src/user/bloc/booking_cubit/booking_state.dart';

import '../../../common/service/api_service.dart';
import 'all_stadium_state.dart';

class StadiumCubit extends Cubit<StadiumState> {
  late DateTime currentDate;
  late List<CarouselSliderController> carouselControllers;
  final TextEditingController searchController = TextEditingController();
  List<StadiumDetail> stadiums = [];
  List<StadiumDetail> filteredStadiums = [];
  int _size = 2;

  StadiumCubit() : super(StadiumInitial()) {
    currentDate = DateTime.now();
    fetchStadiums();
  }

  Future<void> fetchStadiums() async {
    final currentState = state; // 📌 Joriy state-ni olamiz

    // 🔹 Yangi state-ni faqat ma'lumot bo'lmasa yuklaymiz
    if (currentState is! StadiumLoaded) {
      emit(StadiumLoading());
    }

    try {
      final List<StadiumDetail> fetchedStadiums =
      await ApiService().getAllStadiums(size: _size);

      if (currentState is StadiumLoaded) {
        stadiums = List.from(currentState.stadiums)..addAll(fetchedStadiums);
      } else {
        stadiums = fetchedStadiums;
      }

      filteredStadiums = List.from(stadiums);

      // 🔥 carouselControllers faqat yangi elementlar uchun qo'shiladi
      if (currentState is StadiumLoaded) {
        carouselControllers.addAll(
            List.generate(fetchedStadiums.length, (_) => CarouselSliderController()));
      } else {
        carouselControllers =
            List.generate(stadiums.length, (_) => CarouselSliderController());
      }

      _size += 2;

      emit(StadiumLoaded(
        stadiums: List.from(stadiums), // 🔥 Yangi list orqali referensiyani o'zgartiramiz
        filteredStadiums: List.from(filteredStadiums),
        currentIndexList: List.filled(stadiums.length, 0),
        isSearching: false,
      ));
    } catch (e) {
      int? errorCode;
      bool isNetworkError = false;

      if (e is DioException) {
        errorCode = e.response?.statusCode;

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          isNetworkError = true;
        }
      } else if (e is SocketException) {
        isNetworkError = true;
      }

      emit(StadiumError(
        "Xatolik: ${isNetworkError ? "Internet mavjud emas" : e.toString()}",
        errorCode: errorCode,
        isNetworkError: isNetworkError,
      ));
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

  Future<void> refreshStadiums() async {
    await fetchStadiums();
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
