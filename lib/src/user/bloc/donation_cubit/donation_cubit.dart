import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maydon_go/src/common/service/api_service.dart';

import 'donation_state.dart';

class DonationCubit extends Cubit<DonationState> {
  DonationCubit() : super(DonationInitial());

  Future<void> fetchDonations() async {
    emit(DonationLoading());
    try {
      final cards = await ApiService().getUserDonation();
      emit(DonationLoaded(cards));
    } catch (e) {
      emit(DonationError("Xatolik yuz berdi: ${e.toString()}"));
    }
  }
}
