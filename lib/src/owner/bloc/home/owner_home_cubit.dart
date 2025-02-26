import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maydon_go/src/owner/bloc/home/owner_home_state.dart';
import 'package:maydon_go/src/owner/screens/home/add_slot_screen.dart';
import 'package:maydon_go/src/owner/screens/home/bron_list_screen.dart';
import 'package:maydon_go/src/owner/screens/home/owner_profile_screen.dart';

class OwnerHomeCubit extends Cubit<OwnerHomeState> {
  int selectedIndex = 1;

  OwnerHomeCubit() : super(OwnerHomeIntial());

  void updateIndex(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      emit(OwnerHomeLoadedState());
    }
  }

  Widget currentPage() {
    switch (selectedIndex) {
      case 0:
        return const BronListScreen();
      case 1:
        return const AddSlotScreen();
      case 2:
        return  OwnerProfileScreen();

      default:
        return const AddSlotScreen();
    }
  }
}
