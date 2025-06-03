import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:maydon_go/src/common/model/substadium_model.dart';

import '../../../common/model/stadium_model.dart';

class AddStadiumState extends Equatable {
  final StadiumDetail stadium;
  final String name;
  final String description;
  final String price;
  final int count;
  final bool hasUniforms;
  final bool hasBathroom;
  final bool isIndoor;
  final List<File> selectedImages;
  final Map<String, dynamic> locationData;
  final double? latitude;
  final double? longitude;
  final String? errorMessage;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFormSubmitted;
  final Substadiums substadium;
  final List<Substadiums> substadiums; // Yangi maydon qo'shdik
  final bool isLoading;
  final bool hasError;

  AddStadiumState({
    required this.stadium,
    required this.name,
    required this.description,
    required this.price,
    required this.count,
    required this.hasUniforms,
    required this.hasBathroom,
    required this.isIndoor,
    required this.selectedImages,
    required this.locationData,
    required this.latitude,
    required this.longitude,
    required this.errorMessage,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFormSubmitted,
    required this.substadiums, // Yangi maydon
    required this.isLoading,
    required this.substadium,
    required this.hasError,
  });

  factory AddStadiumState.initial() {
    return AddStadiumState(
      stadium: StadiumDetail(name: "No name", id: -1),
      name: '',
      description: '',
      price: '',
      count: 1,
      hasUniforms: false,
      hasBathroom: false,
      isIndoor: false,
      selectedImages: [],
      locationData: {},
      latitude: null,
      longitude: null,
      errorMessage: null,
      isSubmitting: false,
      isSuccess: false,
      substadium: Substadiums(),
      isFormSubmitted: false,
      substadiums: [],
      // Yangi maydon
      isLoading: false,
      hasError: false,
    );
  }

  AddStadiumState copyWith({
    StadiumDetail? stadium,
    String? name,
    String? description,
    String? price,
    int? count,
    bool? hasUniforms,
    bool? hasBathroom,
    bool? isIndoor,
    List<File>? selectedImages,
    Map<String, dynamic>? locationData,
    double? latitude,
    double? longitude,
    String? errorMessage,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFormSubmitted,
    List<Substadiums>? substadiums, // Yangi maydon
    Substadiums? substadium, // Yangi maydon
    bool? isLoading,
    bool? hasError,
  }) {
    return AddStadiumState(
      stadium: stadium ?? this.stadium,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      count: count ?? this.count,
      hasUniforms: hasUniforms ?? this.hasUniforms,
      hasBathroom: hasBathroom ?? this.hasBathroom,
      isIndoor: isIndoor ?? this.isIndoor,
      selectedImages: selectedImages ?? this.selectedImages,
      locationData: locationData ?? this.locationData,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFormSubmitted: isFormSubmitted ?? this.isFormSubmitted,
      substadiums: substadiums ?? this.substadiums,
      substadium: substadium ?? this.substadium,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  @override
  List<Object?> get props => [

        name,
        description,
        price,
        count,
        hasUniforms,
        hasBathroom,
        isIndoor,
        selectedImages,
        locationData,
        latitude,
        longitude,
        errorMessage,
        isSubmitting,
        isSuccess,
        isFormSubmitted,
        substadiums, // Yangi maydon
        isLoading,
        substadium,
        hasError,
      ];
}
