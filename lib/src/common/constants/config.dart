import 'dart:convert';

import 'package:maydon_go/src/common/model/main_model.dart';

import '../model/stadium_model.dart';

final class Config {
  const Config._();

  static const baseUrl = "https://api.maydongo.uz/api";
}


List<Map<String, Object?>> _fakeUserData = [
  {
    "firstName": "Zlatan",
    "lastName": "Ibragimovich",
    "imageUrl":
        "https://www.sueddeutsche.de/2022/06/13/c9f2e64b-d592-4b23-8b4e-fa23dba33395.jpeg?q=60&fm=jpeg&width=1000&rect=258%2C16%2C1086%2C611",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Cristiano",
    "lastName": "Ronaldo",
    "imageUrl":
        "https://i.pinimg.com/736x/77/93/96/7793969fb98b4708cd10940a7698447b.jpg",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Gareth",
    "lastName": "Bale",
    "imageUrl":
        "https://static.independent.co.uk/s3fs-public/thumbnails/image/2016/10/30/11/gareth-bale.jpg",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Isco",
    "lastName": "Alarkon",
    "imageUrl":
        "https://assets.goal.com/images/v3/blt0c94c9bb8603295c/489c012dd7468db530d20fc9008b377e21964b8d.jpg?auto=webp&format=pjpg&width=3840&quality=60",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Joshua",
    "lastName": "Kimmich",
    "imageUrl":
        "https://img.uefa.com/imgml/TP/players/1/2025/324x324/250070417.jpg",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Tony",
    "lastName": "Kroos",
    "imageUrl":
        "https://assets.goal.com/images/v3/bltf115963a5eddd6c0/1783611524.jpg?auto=webp&format=pjpg&width=3840&quality=60",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Marcelo",
    "lastName": "Veira",
    "imageUrl":
        "https://c.ndtvimg.com/2025-02/6pps6hho_marcelo-real-madrid_625x300_06_February_25.jpg?im=FeatureCrop,algorithm=dnn,width=806,height=605",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Dani",
    "lastName": "Carvajal",
    "imageUrl":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRg0WjZzngjwmlCJuy_P3siySXn3D25RBqJ_A&s",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Sergio",
    "lastName": "Ramos",
    "imageUrl":
        "https://assets-cms.thescore.com/uploads/image/file/460601/w640xh480_GettyImages-963665384.jpg?ts=1623872303",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Davide",
    "lastName": "Luiz",
    "imageUrl": "https://stamford-bridge.com/images/player/679.jpg",
    "contactNumber": "+1234567890"
  },
  {
    "firstName": "Iker",
    "lastName": "Casillas",
    "imageUrl":
        "https://img.a.transfermarkt.technology/portrait/big/3979-1684226777.jpeg?lm=1",
    "contactNumber": "+1234567890"
  },
];

// JSONni UserInfo modeliga aylantirish
List<UserModel> $users =
    _fakeUserData.map((json) => UserModel.fromJson(json)).toList();


