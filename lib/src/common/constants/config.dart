import '../model/facilities_model.dart';
import '../model/location_model.dart';
import '../model/stadium_model.dart';

final class Config {
  const Config._();

  static const baseUrl = "https://careful-terrier-pure.ngrok-free.app/api";
}

List<Stadium> $fakeStadiums = [
  Stadium(
    id: 1,
    name:
        "Olimpiyaerfararserraraefafrefaeaerfwrgwrgwgwgrargaergargaragra Stadioni",
    description: "Zamonaviy futbol maydoni, tribuna va tungi yoritish mavjud.",
    price: 150.0,
    location: LocationModel(
      address: "Olimpiya ko'chasi, 12, Toshkent",
      latitude: 41.2995,
      longitude: 69.2401,
    ),
    facilities: Facilities(
      hasBathroom: true,
      isIndoor: false,
      hasUniforms: true,
    ),
    averageRating: 4.8,
    images: [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    ratings: [5, 4, 5, 5, 4],
    availableSlots: {},
  ),
  Stadium(
    id: 2,
    name: "Bunyodkor Arenasi",
    description: "Bunyodkor klubi stadioni, yuqori sifatli qoplamaga ega.",
    price: 200000.0,
    location: LocationModel(
      address: "Amir Temur ko'chasi, Tashkent, Toshkent viloyati, Uzbekistan",
      latitude: 41.3275,
      longitude: 69.2283,
    ),
    facilities: Facilities(
      hasBathroom: true,
      isIndoor: false,
      hasUniforms: false,
    ),
    averageRating: 4.5,
    images: [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    ratings: [5, 5, 4, 2, 4, 5],
    availableSlots: {
      DateTime(2025, 2, 10): [
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 10, 0),
          endTime: DateTime(2025, 2, 10, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 13, 0),
          endTime: DateTime(2025, 2, 10, 14, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 15, 0),
          endTime: DateTime(2025, 2, 10, 16, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 16, 0),
          endTime: DateTime(2025, 2, 10, 17, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 17, 0),
          endTime: DateTime(2025, 2, 10, 18, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 19, 0),
          endTime: DateTime(2025, 2, 10, 20, 0),
        ),TimeSlot(
          startTime: DateTime(2025, 2, 10, 10, 0),
          endTime: DateTime(2025, 2, 10, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 13, 0),
          endTime: DateTime(2025, 2, 10, 14, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 15, 0),
          endTime: DateTime(2025, 2, 10, 16, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 16, 0),
          endTime: DateTime(2025, 2, 10, 17, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 17, 0),
          endTime: DateTime(2025, 2, 10, 18, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 19, 0),
          endTime: DateTime(2025, 2, 10, 20, 0),
        ),TimeSlot(
          startTime: DateTime(2025, 2, 10, 10, 0),
          endTime: DateTime(2025, 2, 10, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 13, 0),
          endTime: DateTime(2025, 2, 10, 14, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 15, 0),
          endTime: DateTime(2025, 2, 10, 16, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 16, 0),
          endTime: DateTime(2025, 2, 10, 17, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 17, 0),
          endTime: DateTime(2025, 2, 10, 18, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 19, 0),
          endTime: DateTime(2025, 2, 10, 20, 0),
        ),TimeSlot(
          startTime: DateTime(2025, 2, 10, 10, 0),
          endTime: DateTime(2025, 2, 10, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 13, 0),
          endTime: DateTime(2025, 2, 10, 14, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 15, 0),
          endTime: DateTime(2025, 2, 10, 16, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 16, 0),
          endTime: DateTime(2025, 2, 10, 17, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 17, 0),
          endTime: DateTime(2025, 2, 10, 18, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 19, 0),
          endTime: DateTime(2025, 2, 10, 20, 0),
        ), TimeSlot(
          startTime: DateTime(2025, 2, 10, 10, 0),
          endTime: DateTime(2025, 2, 10, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 13, 0),
          endTime: DateTime(2025, 2, 10, 14, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 15, 0),
          endTime: DateTime(2025, 2, 10, 16, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 16, 0),
          endTime: DateTime(2025, 2, 10, 17, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 17, 0),
          endTime: DateTime(2025, 2, 10, 18, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 19, 0),
          endTime: DateTime(2025, 2, 10, 20, 0),
        ),
      ],
      DateTime(2025, 2, 11): [
        TimeSlot(
          startTime: DateTime(2025, 2, 11, 10, 0),
          endTime: DateTime(2025, 2, 11, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 11, 13, 0),
          endTime: DateTime(2025, 2, 11, 14, 0),
        ),
      ],
      DateTime(2025, 2, 14): [
        TimeSlot(
          startTime: DateTime(2025, 2, 14, 10, 0),
          endTime: DateTime(2025, 2, 14, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 14, 13, 0),
          endTime: DateTime(2025, 2, 14, 14, 0),
        ),
      ],
      DateTime(2025, 2, 15): [
        TimeSlot(
          startTime: DateTime(2025, 2, 15, 10, 0),
          endTime: DateTime(2025, 2, 15, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 15, 13, 0),
          endTime: DateTime(2025, 2, 15, 14, 0),
        ),
      ],
      DateTime(2025, 2, 20): [
        TimeSlot(
          startTime: DateTime(2025, 2, 20, 10, 0),
          endTime: DateTime(2025, 2, 20, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 20, 13, 0),
          endTime: DateTime(2025, 2, 20, 14, 0),
        ),
      ],
      DateTime(2025, 3, 14): [
        TimeSlot(
          startTime: DateTime(2025, 3, 14, 10, 0),
          endTime: DateTime(2025, 3, 14, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 3, 14, 13, 0),
          endTime: DateTime(2025, 3, 14, 14, 0),
        ),
      ],
      DateTime(2025, 3, 15): [
        TimeSlot(
          startTime: DateTime(2025, 3, 15, 10, 0),
          endTime: DateTime(2025, 3, 14, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 3, 15, 13, 0),
          endTime: DateTime(2025, 3, 15, 14, 0),
        ),
      ],
      DateTime(2025, 3, 2): [
        TimeSlot(
          startTime: DateTime(2025, 3, 2, 10, 0),
          endTime: DateTime(2025, 3, 2, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 3, 2, 13, 0),
          endTime: DateTime(2025, 3, 2, 14, 0),
        ),
      ],
      DateTime(2025, 3, 10): [
        TimeSlot(
          startTime: DateTime(2025, 3, 10, 10, 0),
          endTime: DateTime(2025, 3, 10, 11, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 3, 10, 13, 0),
          endTime: DateTime(2025, 3, 10, 14, 0),
        ),
      ],
    },
  ),
  Stadium(
    id: 3,
    name: "Paxtakor Stadioni",
    description: "O'zbekistonning eng katta stadionlaridan biri.",
    price: 180.0,
    location: LocationModel(
      address: "Paxtakor maydoni, 3, Toshkent",
      latitude: 41.3156,
      longitude: 69.2488,
    ),
    facilities: Facilities(
      hasBathroom: false,
      isIndoor: false,
      hasUniforms: true,
    ),
    averageRating: 4.7,
    images: [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    ratings: [5, 4, 4, 5, 5],
    availableSlots: {
      DateTime(2025, 2, 10): [
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 14, 0),
          endTime: DateTime(2025, 2, 10, 15, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 16, 0),
          endTime: DateTime(2025, 2, 10, 17, 0),
        ),
      ],
    },
  ),
  Stadium(
    id: 4,
    name: "Navbahor Arenasi",
    description: "Namangandagi eng zamonaviy stadionlardan biri.",
    price: 130.0,
    location: LocationModel(
      address: "Navbahor ko'chasi, 8, Namangan",
      latitude: 40.9983,
      longitude: 71.6726,
    ),
    facilities: Facilities(
      hasBathroom: true,
      isIndoor: false,
      hasUniforms: false,
    ),
    averageRating: 4.2,
    images: [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    ratings: [4, 4, 5, 3, 4],
    availableSlots: {
      DateTime(2025, 2, 10): [
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 15, 0),
          endTime: DateTime(2025, 2, 10, 16, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 17, 0),
          endTime: DateTime(2025, 2, 10, 18, 0),
        ),
      ],
    },
  ),
  Stadium(
    id: 5,
    name: "Dinamo Sport Majmuasi",
    description:
        "Multifunksional stadion, futbol va yengil atletika uchun mos.",
    price: 120.0,
    location: LocationModel(
      address: "Dinamo ko'chasi, 6, Samarqand",
      latitude: 39.6545,
      longitude: 66.9744,
    ),
    facilities: Facilities(
      hasBathroom: false,
      isIndoor: true,
      hasUniforms: true,
    ),
    averageRating: 4.4,
    images: [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    ratings: [5, 4, 4, 4, 5],
    availableSlots: {
      DateTime(2025, 2, 10): [
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 9, 0),
          endTime: DateTime(2025, 2, 10, 10, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 11, 0),
          endTime: DateTime(2025, 2, 10, 12, 0),
        ),
      ],
    },
  ),
  Stadium(
    id: 6,
    name: "Andijon Markaziy Stadioni",
    description: "Andijondagi asosiy stadion, keng maydonga ega.",
    price: 140.0,
    location: LocationModel(
      address: "Stadion ko'chasi, 2, Andijon",
      latitude: 40.7872,
      longitude: 72.3455,
    ),
    facilities: Facilities(
      hasBathroom: true,
      isIndoor: false,
      hasUniforms: false,
    ),
    averageRating: 4.3,
    images: [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    ratings: [4, 5, 4, 3, 5],
    availableSlots: {
      DateTime(2025, 2, 10): [
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 13, 0),
          endTime: DateTime(2025, 2, 10, 14, 0),
        ),
        TimeSlot(
          startTime: DateTime(2025, 2, 10, 15, 0),
          endTime: DateTime(2025, 2, 10, 16, 0),
        ),
      ],
    },
  ),
];
