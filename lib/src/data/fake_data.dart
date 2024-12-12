import '../model/stadium_model.dart';

class FakeData {
  static List<StadiumOwner> stadiumOwners = [
    StadiumOwner(
      id: 0,
      phoneNumber: "123-456-7890",
      role: "Owner",
      userInfo: UserInfo(
        firstName: "John",
        lastName: "Doe",
        imageUrl: "assets/images/owner1.jpg",
        contactNumber: "123-456-7890",
        telegramUsername: "johndoe123",
      ),
      stadium: Stadium(
        id: 0,
        name: "Parvoz",
        description: "A large football stadium with great facilities.",
        price: 200.0,
        location: Location(
          address: "123 Stadium Lane, Tashkent, Uzbekistan",
          latitude: 41.2995,
          longitude: 69.2401,
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: true,
          hasUniforms: true,
        ),
        images: [
          'assets/images/stadion_image1.png',
          'assets/images/stadion_image2.png',
          'assets/images/stadion_image3.jfif',
          'assets/images/stadion_image4.webp',
        ],
      ),
      active: true,
    ),
    StadiumOwner(
      id: 1,
      phoneNumber: "987-654-3210",
      role: "Owner",
      userInfo: UserInfo(
        firstName: "Jane",
        lastName: "Smith",
        imageUrl: "assets/images/owner2.jpg",
        contactNumber: "987-654-3210",
        telegramUsername: "janesmith987",
      ),
      stadium: Stadium(
        id: 1,
        name: "Drujba narodov",
        description: "A modern indoor stadium with air conditioning.",
        price: 300.0,
        location: Location(
          address: "456 Indoor Arena Blvd, Samarkand, Uzbekistan",
          latitude: 39.6541,
          longitude: 66.9750,
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: true,
          hasUniforms: false,
        ),
        images: [
          'assets/images/stadion_image1.png',
          'assets/images/stadion_image2.png',
          'assets/images/stadion_image3.jfif',
          'assets/images/stadion_image4.webp',
        ],
      ),
      active: true,
    ),
    StadiumOwner(
      id: 2,
      phoneNumber: "555-123-4567",
      role: "Owner",
      userInfo: UserInfo(
        firstName: "Ali",
        lastName: "Khan",
        imageUrl: "assets/images/owner3.jpg",
        contactNumber: "555-123-4567",
        telegramUsername: "alikhan555",
      ),
      stadium: Stadium(
        id: 2,
        name: "Novza stadium",
        description: "An open-air stadium with beautiful mountain views.",
        price: 150.0,
        location: Location(
          address: "789 Mountain Road, Fergana, Uzbekistan",
          latitude: 40.3884,
          longitude: 71.7869,
        ),
        facilities: Facilities(
          hasBathroom: false,
          hasRestroom: true,
          hasUniforms: true,
        ),
        images: [
          'assets/images/stadion_image1.png',
          'assets/images/stadion_image2.png',
          'assets/images/stadion_image3.jfif',
          'assets/images/stadion_image4.webp',
        ],
      ),
      active: false,
    ),
    StadiumOwner(
      id: 3,
      phoneNumber: "222-333-4444",
      role: "Owner",
      userInfo: UserInfo(
        firstName: "Maria",
        lastName: "Lopez",
        imageUrl: "assets/images/owner4.jpg",
        contactNumber: "222-333-4444",
        telegramUsername: "marialopez22",
      ),
      stadium: Stadium(
        id: 3,
        name: "Alianz Arena",
        description: "A community stadium perfect for local events.",
        price: 100.0,
        location: Location(
          address: "101 Community Park, Bukhara, Uzbekistan",
          latitude: 39.7747,
          longitude: 64.4286,
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: false,
          hasUniforms: false,
        ),
        images: [
          'assets/images/stadion_image1.png',
          'assets/images/stadion_image2.png',
          'assets/images/stadion_image3.jfif',
          'assets/images/stadion_image4.webp',
        ],
      ),
      active: true,
    ),
    StadiumOwner(
      id: 4,
      phoneNumber: "777-888-9999",
      role: "Owner",
      userInfo: UserInfo(
        firstName: "David",
        lastName: "Kim",
        imageUrl: "assets/images/owner5.jpg",
        contactNumber: "777-888-9999",
        telegramUsername: "davidkim77",
      ),
      stadium: Stadium(
        id: 4,
        name: "Maksim Gorkiy 3",
        description: "A premium stadium with VIP lounges and seating.",
        price: 500.0,
        location: Location(
          address: "202 VIP Lane, Tashkent, Uzbekistan",
          latitude: 41.3275,
          longitude: 69.2818,
        ),
        facilities: Facilities(
          hasBathroom: true,
          hasRestroom: true,
          hasUniforms: true,
        ),
        images: [
          'assets/images/stadion_image1.png',
          'assets/images/stadion_image2.png',
          'assets/images/stadion_image3.jfif',
          'assets/images/stadion_image4.webp',
        ],
      ),
      active: true,
    ),
  ];
}
