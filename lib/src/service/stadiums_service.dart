import 'package:maydon_go/src/model/stadium_model.dart';

import '../data/fake_data.dart';

class StadiumService {
  // Future method for fetching stadiums, could be expanded to fetch from an API
  Future<List<Stadium>> fetchStadiums() async {
    // For now, returning fake data
    return FakeData.stadiumOwners.map((e) => e.stadium).toList();
  }
}
