

import 'dart:io';

import 'package:equatable/equatable.dart';

enum AddStadiumStatus { initial, loading, success, error }

class AddStadiumState extends Equatable {
  final String name;
  final String description;
  final String price;
  final String count;
  final List<File> selectedImages;
  final bool hasBathroom;
  final bool isIndoor;
  final bool hasUniforms;
  final AddStadiumStatus status;
  final String? errorMessage;

  const AddStadiumState({
    this.name = '',
    this.description = '',
    this.price = '',
    this.count = '',
    this.selectedImages = const [],
    this.hasBathroom = false,
    this.isIndoor = false,
    this.hasUniforms = false,
    this.status = AddStadiumStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    name,
    description,
    price,
    count,
    selectedImages,
    hasBathroom,
    isIndoor,
    hasUniforms,
    status,
    errorMessage,
  ];

  AddStadiumState copyWith({
    String? name,
    String? description,
    String? price,
    String? count,
    List<File>? selectedImages,
    bool? hasBathroom,
    bool? isIndoor,
    bool? hasUniforms,
    AddStadiumStatus? status,
    String? errorMessage,
  }) {
    return AddStadiumState(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      count: count ?? this.count,
      selectedImages: selectedImages ?? this.selectedImages,
      hasBathroom: hasBathroom ?? this.hasBathroom,
      isIndoor: isIndoor ?? this.isIndoor,
      hasUniforms: hasUniforms ?? this.hasUniforms,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid =>
      name.isNotEmpty &&
          description.isNotEmpty &&
          price.isNotEmpty &&
          count.isNotEmpty;
}