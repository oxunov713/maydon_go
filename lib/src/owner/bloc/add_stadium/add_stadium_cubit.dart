import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/facilities_model.dart';
import '../../../common/model/location_model.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/model/time_slot_model.dart';
import 'add_stadium_state.dart';

class AddStadiumCubit extends Cubit<AddStadiumState> {
  AddStadiumCubit() : super(AddStadiumInitial());

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updatePrice(double price) {
    emit(state.copyWith(price: price));
  }

  void updateLocation(LocationModel location) {
    emit(state.copyWith(location: location));
  }

  void updateFacilities(Facilities facilities) {
    emit(state.copyWith(facilities: facilities));
  }

  void updateAverageRating(double averageRating) {
    emit(state.copyWith(averageRating: averageRating));
  }

  void updateImages(List<String> images) {
    emit(state.copyWith(images: images));
  }

  void updateRatings(List<int> ratings) {
    emit(state.copyWith(ratings: ratings));
  }

  void updateStadiumCount(int stadiumCount) {
    emit(state.copyWith(stadiumCount: stadiumCount));
  }

  void updateStadiumsSlots(List<Map<String, Map<DateTime, List<TimeSlot>>>> stadiumsSlots) {
    emit(state.copyWith(stadiumsSlots: stadiumsSlots));
  }
}