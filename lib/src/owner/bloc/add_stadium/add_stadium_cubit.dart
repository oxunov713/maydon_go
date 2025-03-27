// lib/src/features/stadium_management/presentation/cubit/stadium_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'add_stadium_state.dart';

class AddStadiumCubit extends Cubit<AddStadiumState> {
  AddStadiumCubit() : super(const AddStadiumState());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updatePrice(String price) {
    emit(state.copyWith(price: price));
  }

  void updateCount(String count) {
    emit(state.copyWith(count: count));
  }

  void toggleHasBathroom() {
    emit(state.copyWith(hasBathroom: !state.hasBathroom));
  }

  void toggleIsIndoor() {
    emit(state.copyWith(isIndoor: !state.isIndoor));
  }

  void toggleHasUniforms() {
    emit(state.copyWith(hasUniforms: !state.hasUniforms));
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      emit(state.copyWith(
        selectedImages: images.map((image) => File(image.path)).toList(),
      ));
    }
  }

  void clearImages() {
    emit(state.copyWith(selectedImages: []));
  }

  Future<void> submitStadium() async {
    if (state.name.isEmpty ||
        state.description.isEmpty ||
        state.price.isEmpty ||
        state.count.isEmpty) {
      emit(state.copyWith(status: AddStadiumStatus.error));
      return;
    }

    emit(state.copyWith(status: AddStadiumStatus.loading));

    try {
      // Here you would typically call your repository to save the stadium
      // await stadiumRepository.addStadium(state.toStadiumModel());
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      emit(state.copyWith(status: AddStadiumStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: AddStadiumStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void reset() {
    emit(const AddStadiumState());
  }
}
