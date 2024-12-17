import '../model/stadium_model.dart';

class FakeData {
  static List<StadiumOwner> stadiumOwners = [
    StadiumOwner(
      id: 1,
      phoneNumber: "+998901234567",
      role: "Admin",
      active: true,
      userInfo: UserInfo(
        firstName: "Ali",
        lastName: "Valiyev",
        imageUrl: "https://example.com/user1.jpg",
        contactNumber: "+998901234567",
        telegramUsername: "@ali_valiyev",
      ),
      stadium: Stadium(
        id: 1,
        name: "Milliy Stadion",
        ratings: 4.6,
        description: "Milliy o'yinlar uchun maxsus stadion",
        price: 500000,
        availableSlots: [
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 14),
            endTime: DateTime(2024, 12, 25, 15),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 15),
            endTime: DateTime(2024, 12, 25, 15, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 20),
            endTime: DateTime(2024, 12, 25, 20, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 21),
            endTime: DateTime(2024, 12, 25, 22),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 23),
            endTime: DateTime(2024, 12, 25, 24, 30),
          ),
        ],
        location: LocationModel(
          latitude: 41.312336,
          longitude: 69.278707,
          address: "Toshkent, Chilonzor tumani",
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: true,
          hasUniforms: false,
        ),
        images: [
          "assets/images/stadion_image1.png",
          "assets/images/stadion_image2.png",
        ],
      ),
    ),
    StadiumOwner(
      id: 2,
      phoneNumber: "+998902345678",
      role: "Manager",
      active: true,
      userInfo: UserInfo(
        firstName: "Bobur",
        lastName: "Karimov",
        imageUrl: "https://example.com/user2.jpg",
        contactNumber: "+998902345678",
        telegramUsername: "@bobur_karimov",
      ),
      stadium: Stadium(
        id: 2,
        name: "Paxtakor Stadion",
        description: "Paxtakor futbol jamoasi uyi",
        price: 450000,
        ratings: 5,
        availableSlots: [
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 16),
            endTime: DateTime(2024, 12, 25, 17),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 17),
            endTime: DateTime(2024, 12, 25, 17, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 26, 20),
            endTime: DateTime(2024, 12, 26, 20, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 26, 21),
            endTime: DateTime(2024, 12, 26, 22),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 27, 23),
            endTime: DateTime(2024, 12, 27, 24, 30),
          ),
        ],
        location: LocationModel(
          latitude: 41.326231,
          longitude: 69.291634,
          address: "Toshkent, Shayxontohur tumani",
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: true,
          hasUniforms: true,
        ),
        images: [
          "assets/images/stadion_image3.jfif",
        ],
      ),
    ),
    StadiumOwner(
      id: 3,
      phoneNumber: "+998903456789",
      role: "Owner",
      active: false,
      userInfo: UserInfo(
        firstName: "Dilshod",
        lastName: "Nazarov",
        imageUrl: "https://example.com/user3.jpg",
        contactNumber: "+998903456789",
        telegramUsername: "@dilshod_nazarov",
      ),
      stadium: Stadium(
        id: 3,
        name: "Bunyodkor Stadion",
        description: "Zamonaviy stadion",
        price: 600000,
        ratings: 4.9,
        availableSlots: [
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 16),
            endTime: DateTime(2024, 12, 25, 17),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 17),
            endTime: DateTime(2024, 12, 25, 17, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 20),
            endTime: DateTime(2024, 12, 25, 20, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 26, 20),
            endTime: DateTime(2024, 12, 26, 21),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 27, 20),
            endTime: DateTime(2024, 12, 27, 20, 30),
          ),
        ],
        location: LocationModel(
          latitude: 41.299496,
          longitude: 69.240073,
          address: "Toshkent, Mirzo Ulug'bek tumani",
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: false,
          hasUniforms: true,
        ),
        images: [
          "assets/images/stadion_image4.jpg",
          "assets/images/stadion_image2.png",
          "assets/images/stadion_image1.png",
        ],
      ),
    ),
    StadiumOwner(
      id: 4,
      phoneNumber: "+998904567890",
      role: "Manager",
      active: true,
      userInfo: UserInfo(
        firstName: "Elyor",
        lastName: "Tursunov",
        imageUrl: "https://example.com/user4.jpg",
        contactNumber: "+998904567890",
        telegramUsername: "@elyor_tursunov",
      ),
      stadium: Stadium(
        id: 4,
        name: "Lokomotiv Stadion",
        description: "Lokomotiv futbol jamoasi uchun",
        price: 400000,
        ratings: 4.2,
        availableSlots: [
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 16),
            endTime: DateTime(2024, 12, 25, 17),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 17),
            endTime: DateTime(2024, 12, 25, 17, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 20),
            endTime: DateTime(2024, 12, 25, 20, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 21),
            endTime: DateTime(2024, 12, 25, 22),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 27, 17),
            endTime: DateTime(2024, 12, 27, 17, 30),
          ),
        ],
        location: LocationModel(
          latitude: 41.288652,
          longitude: 69.256041,
          address: "Toshkent, Yakkasaroy tumani",
        ),
        facilities: Facilities(
          hasBathroom: false,
          hasRestroom: true,
          hasUniforms: false,
        ),
        images: [
          "assets/images/stadion_image5.webp",
          "assets/images/stadion_image6.jpg",
          "assets/images/stadion_image7.jpg",
          "assets/images/stadion_image1.png"
        ],
      ),
    ),
    StadiumOwner(
      id: 5,
      phoneNumber: "+998905678901",
      role: "Owner",
      active: false,
      userInfo: UserInfo(
        firstName: "Farhod",
        lastName: "Sobirov",
        imageUrl: "https://example.com/user5.jpg",
        contactNumber: "+998905678901",
        telegramUsername: "@farhod_sobirov",
      ),
      stadium: Stadium(
        id: 5,
        name: "Jar Stadion",
        description: "Turli tadbirlar uchun stadion",
        price: 550000,
        ratings: 5,
        availableSlots: [
          AvailableSlot(
            startTime: DateTime(2024, 12, 25, 16),
            endTime: DateTime(2024, 12, 25, 17),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 26, 20),
            endTime: DateTime(2024, 12, 26, 20, 30),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 26, 21),
            endTime: DateTime(2024, 12, 26, 22),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 26, 22),
            endTime: DateTime(2024, 12, 26, 23),
          ),
          AvailableSlot(
            startTime: DateTime(2024, 12, 27, 21),
            endTime: DateTime(2024, 12, 27, 22),
          ),
        ],
        location: LocationModel(
          latitude: 41.313101,
          longitude: 69.243951,
          address: "Toshkent, Yunusobod tumani",
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: true,
          hasUniforms: true,
        ),
        images: [
          "assets/images/stadion_image8.webp",
          "assets/images/stadion_image9.webp",
          "assets/images/stadion_image4.jpg"
        ],
      ),
    ),
  ];
}
