import '../../../common/model/facilities_model.dart';
import '../../../common/model/location_model.dart';
import '../../../common/model/stadium_model.dart';
import '../../../common/model/time_slot_model.dart';

class AddStadiumState {
  final int id;
  final String name;
  final String description;
  final double price;
  final LocationModel location;
  final Facilities facilities;
  final double averageRating;
  final List<String> images;
  final List<int> ratings;
  final int stadiumCount;
  final List<Map<String, Map<DateTime, List<TimeSlot>>>> stadiumsSlots;

  AddStadiumState({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.location,
    required this.facilities,
    required this.averageRating,
    required this.images,
    required this.ratings,
    required this.stadiumCount,
    required this.stadiumsSlots,
  });

  AddStadiumState copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    LocationModel? location,
    Facilities? facilities,
    double? averageRating,
    List<String>? images,
    List<int>? ratings,
    int? stadiumCount,
    List<Map<String, Map<DateTime, List<TimeSlot>>>>? stadiumsSlots,
  }) {
    return AddStadiumState(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      location: location ?? this.location,
      facilities: facilities ?? this.facilities,
      averageRating: averageRating ?? this.averageRating,
      images: images ?? this.images,
      ratings: ratings ?? this.ratings,
      stadiumCount: stadiumCount ?? this.stadiumCount,
      stadiumsSlots: stadiumsSlots ?? this.stadiumsSlots,
    );
  }
}

class AddStadiumInitial extends AddStadiumState {
  AddStadiumInitial()
      : super(
          id: 0,
          name: '',
          description: '',
          price: 0.0,
          location: LocationModel(
              latitude: 0.0,
              longitude: 0.0,

              city: '',
              country: '',
              street: ''),
          facilities: Facilities(
              hasBathroom: false, isIndoor: false, hasUniforms: false),
          averageRating: 0.0,
          images: [],
          ratings: [],
          stadiumCount: 0,
          stadiumsSlots: [],
        );
}
