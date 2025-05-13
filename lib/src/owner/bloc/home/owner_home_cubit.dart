import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/main_model.dart';
import '../../../common/service/api/api_client.dart';
import '../../../common/service/api/user_service.dart';
import '../../screens/home/add_slot_screen.dart';
import '../../screens/home/bron_list_screen.dart';
import '../../screens/home/owner_profile_screen.dart';
import 'owner_home_state.dart';

class OwnerHomeCubit extends Cubit<OwnerHomeState> {
  int selectedIndex = 1;

  OwnerHomeCubit() : super(OwnerHomeIntial());

  void updateIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      emit(OwnerHomeLoadedState(<SubscriptionModel>[], selectedIndex: index));
    }
  }

  Widget currentPage() {
    switch (selectedIndex) {
      case 0:
        return const BronListScreen();
      case 1:
        return const AddSlotScreen();
      case 2:
        return OwnerProfileScreen();

      default:
        return const AddSlotScreen();
    }
  }

  Future<void> fetchSubscriptions() async {
    try {
      emit(OwnerHomeLoading(selectedIndex: selectedIndex));
      final subscriptions =
          await UserService(ApiClient().dio).getOwnerSubscription();
      emit(OwnerHomeLoadedState(subscriptions, selectedIndex: selectedIndex));
    } catch (e) {
      emit(OwnerHomeError(e.toString(), selectedIndex: selectedIndex));
    }
  }
}
