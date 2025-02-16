import 'dart:convert';

import '../model/stadium_model.dart';
import '../model/userinfo_model.dart';

final class Config {
  const Config._();

  static const baseUrl = "https://careful-terrier-pure.ngrok-free.app/api";
}

List parsedJson = jsonDecode(_jsonData);
List<StadiumDetail> $fakeData =
    parsedJson.map((json) => StadiumDetail.fromJson(json)).toList();
List<Map<String, Object?>> _fakeUserData = [
  {
    "firstName": "John",
    "lastName": "Doe",
    "imageUrl": "https://randomuser.me/api/portraits/men/1.jpg",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Jane",
    "lastName": "Smith",
    "imageUrl": "https://randomuser.me/api/portraits/women/2.jpg",
    "contactNumber": "+9876543210"
  },
  {
    "firstName": "Alice",
    "lastName": "Brown",
    "imageUrl": "https://randomuser.me/api/portraits/women/3.jpg",
    "contactNumber": "+1122334455"
  },
  {
    "firstName": "Michael",
    "lastName": "Johnson",
    "imageUrl": "https://randomuser.me/api/portraits/men/4.jpg",
    "contactNumber": "+5566778899"
  },
  {
    "firstName": "Emily",
    "lastName": "Davis",
    "imageUrl": "",
    "contactNumber": "+6677889900"
  }
];

// JSONni UserInfo modeliga aylantirish
List<UserInfo> $users =
    _fakeUserData.map((json) => UserInfo.fromJson(json)).toList();

const String _jsonData = """[
  {
    "id": 1,
    "name": "Stadium Complex 1",
    "description": "A large stadium complex with multiple fields.",
    "price": 100000,
    "location": {
      "address": "Shayxontohur tuman, Chilonzor ko'chasi, 50",
      "latitude": 41.311081,
      "longitude": 69.240562
    },
    "facilities": {"hasBathroom": true, "isIndoor": false, "hasUniforms": true},
    "averageRating": 4.5,
     "images": [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    "ratings": [4, 5, 4],
    "stadiumCount": 3,
    "stadiumsSlots": [
      {
        "Stadium 1A": {
          "2025-02-10T10:00:00": [
            {
              "startTime": "2025-02-10T10:00:00",
              "endTime": "2025-02-10T12:00:00"
            },
            {
              "startTime": "2025-02-10T12:00:00",
              "endTime": "2025-02-10T14:00:00"
            },
            {
              "startTime": "2025-02-10T14:00:00",
              "endTime": "2025-02-10T16:00:00"
            },
            {
              "startTime": "2025-02-10T16:00:00",
              "endTime": "2025-02-10T18:00:00"
            }
          ],"2023-10-09T10:00:00": [
            {
              "startTime": "2023-10-09T10:00:00",
              "endTime": "2023-10-09T12:00:00"
            },
            {
              "startTime": "2023-10-09T12:00:00",
              "endTime": "2023-10-09T14:00:00"
            },
            {
              "startTime": "2023-10-09T14:00:00",
              "endTime": "2023-10-09T16:00:00"
            },
            {
              "startTime": "2023-10-09T16:00:00",
              "endTime": "2023-10-09T18:00:00"
            }
          ],"2023-10-10T10:00:00": [
            {
              "startTime": "2023-10-10T10:00:00",
              "endTime": "2023-10-10T12:00:00"
            },
            {
              "startTime": "2023-10-10T12:00:00",
              "endTime": "2023-10-10T14:00:00"
            },
            {
              "startTime": "2023-10-10T14:00:00",
              "endTime": "2023-10-10T16:00:00"
            },
            {
              "startTime": "2023-10-10T16:00:00",
              "endTime": "2023-10-10T18:00:00"
            }
          ],"2023-10-11T10:00:00": [
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            },
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            }
          ],"2023-10-12T10:00:00": [
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            },
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            }
          ],"2023-10-16T10:00:00": [
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            },
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            }
          ],"2025-02-13T08:00:00": [
            {
              "startTime": "2023-10-08T08:00:00",
              "endTime": "2023-10-08T10:00:00"
            },
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            }
          ],"2025-02-15T10:00:00": [
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            },
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            }
          ],"2023-13-08T10:00:00": [
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            },
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            }
          ]
        }
      },
      {
        "Stadium 1B": {
          "2023-10-08T12:00:00": [
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            },
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            },
            {
              "startTime": "2023-10-08T18:00:00",
              "endTime": "2023-10-08T20:00:00"
            }
          ]
        }
      },
      {
        "Stadium 1C": {
          "2025-02-13T08:00:00": [
            {
              "startTime": "2023-10-08T08:00:00",
              "endTime": "2023-10-08T10:00:00"
            },
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            }
          ]
        }
      }
    ]
  },
  {
    "id": 2,
    "name": "Stadium Complex 2",
    "description": "A modern stadium with advanced facilities.",
    "price": 150000,
    "location": {
      "address": "Samarkand, Rudaki ko'chasi, 12",
      "latitude": 39.654167,
      "longitude": 66.959722
    },
    "facilities": {"hasBathroom": true, "isIndoor": true, "hasUniforms": false},
    "averageRating": 4.7,
    "images": [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    "ratings": [5, 5, 4],
    "stadiumCount": 2,
    "stadiumsSlots": [
      {
        "Stadium 2A": {
          "2023-10-08T09:00:00": [
            {
              "startTime": "2023-10-08T09:00:00",
              "endTime": "2023-10-08T11:00:00"
            },
            {
              "startTime": "2023-10-08T11:00:00",
              "endTime": "2023-10-08T13:00:00"
            },
            {
              "startTime": "2023-10-08T13:00:00",
              "endTime": "2023-10-08T15:00:00"
            },
            {
              "startTime": "2023-10-08T15:00:00",
              "endTime": "2023-10-08T17:00:00"
            }
          ]
        }
      },
      {
        "Stadium 2B": {
          "2023-02-15T11:00:00": [
            {
              "startTime": "2023-10-08T11:00:00",
              "endTime": "2023-10-08T13:00:00"
            },
            {
              "startTime": "2023-10-08T13:00:00",
              "endTime": "2023-10-08T15:00:00"
            },
            {
              "startTime": "2023-10-08T15:00:00",
              "endTime": "2023-10-08T17:00:00"
            },
            {
              "startTime": "2023-10-08T17:00:00",
              "endTime": "2023-10-08T19:00:00"
            }
          ]
        }
      }
    ]
  },
  {
    "id": 3,
    "name": "Stadium Complex 3",
    "description": "A cozy stadium with a great atmosphere.",
    "price": 120000,
    "location": {
      "address": "Bukhara, Mustaqillik ko'chasi, 8",
      "latitude": 39.775556,
      "longitude": 64.428611
    },
    "facilities": {"hasBathroom": true, "isIndoor": false, "hasUniforms": true},
    "averageRating": 4.3,
     "images": [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    "ratings": [4, 4, 5],
    "stadiumCount": 4,
    "stadiumsSlots": [
      {
        "Stadium 3B": {
          "2023-10-08T10:00:00": [
            {
              "startTime": "2023-10-08T10:00:00",
              "endTime": "2023-10-08T12:00:00"
            },
            {
              "startTime": "2023-10-08T12:00:00",
              "endTime": "2023-10-08T14:00:00"
            },
            {
              "startTime": "2023-10-08T14:00:00",
              "endTime": "2023-10-08T16:00:00"
            },
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            }
          ]
        }
      },
       {
        "Stadium 3A": {
          "2025-02-16T08:00:00": [
            {
              "startTime": "2025-02-16T08:00:00",
              "endTime": "2025-02-16T10:00:00"
            },
            {
              "startTime": "2025-02-16T10:00:00",
              "endTime": "2025-02-16T12:00:00"
            },
            {
              "startTime": "2025-02-16T12:00:00",
              "endTime": "2025-02-16T14:00:00"
            },
            {
              "startTime": "2025-02-16T14:00:00",
              "endTime": "2025-02-16T16:00:00"
            }
          ]
        }
      },
      {
        "Stadium 3C": {
          "2023-10-08T16:00:00": [
            {
              "startTime": "2023-10-08T16:00:00",
              "endTime": "2023-10-08T18:00:00"
            },
            {
              "startTime": "2023-10-08T18:00:00",
              "endTime": "2023-10-08T20:00:00"
            },
            {
              "startTime": "2023-10-08T20:00:00",
              "endTime": "2023-10-08T22:00:00"
            },
            {
              "startTime": "2023-10-08T22:00:00",
              "endTime": "2023-10-09T00:00:00"
            }
          ]
        }
      },
      {
        "Stadium 3D": {
          "2023-10-08T18:00:00": [
            {
              "startTime": "2023-10-08T18:00:00",
              "endTime": "2023-10-08T20:00:00"
            },
            {
              "startTime": "2023-10-08T20:00:00",
              "endTime": "2023-10-08T22:00:00"
            },
            {
              "startTime": "2023-10-08T22:00:00",
              "endTime": "2023-10-09T00:00:00"
            },
            {
              "startTime": "2023-10-09T00:00:00",
              "endTime": "2023-10-09T02:00:00"
            }
          ]
        }
      }
    ]
  },
  {
    "id": 4,
    "name": "Stadium Complex 4",
    "description": "A family-friendly stadium with great amenities.",
    "price": 90000,
    "location": {
      "address": "Khiva, Ichan-Qala ko'chasi, 20",
      "latitude": 41.378333,
      "longitude": 60.361944
    },
    "facilities": {"hasBathroom": true, "isIndoor": true, "hasUniforms": true},
    "averageRating": 4.8,
     "images": [
      "https://frankfurt.apollo.olxcdn.com/v1/files/m9gnr05wrlao1-UZ/image",
      "https://frankfurt.apollo.olxcdn.com/v1/files/13k8pil4vcdl2-UZ/image;s=960x1280",
      "https://media.cgtrader.com/variants/VLCxBmVdo1aspXBc74XQp7Di/64d1262c1acde2eb3beef249c4695a8ad88c958dd79db36f763bf631017addd0/5d3f46ee-a175-4a58-832d-6d50a90c2d0b.jpg"
    ],
    "ratings": [5, 5, 5],
    "stadiumCount": 1,
    "stadiumsSlots": [
      {
        "Stadium 4A": {
          "2023-10-08T07:00:00": [
            {
              "startTime": "2023-10-08T07:00:00",
              "endTime": "2023-10-08T09:00:00"
            },
            {
              "startTime": "2023-10-08T09:00:00",
              "endTime": "2023-10-08T11:00:00"
            },
            {
              "startTime": "2023-10-08T11:00:00",
              "endTime": "2023-10-08T13:00:00"
            },
            {
              "startTime": "2023-10-08T13:00:00",
              "endTime": "2023-10-08T15:00:00"
            }
          ]
        }
      }
    ]
  }
]""";
