import 'package:bloc/bloc.dart';

import '../../../common/service/api/api_client.dart';
import '../../../common/service/api/user_service.dart';
import 'donation_state.dart';

class DonationCubit extends Cubit<DonationState> {
  DonationCubit() : super(DonationInitial());

  Future<void> fetchDonations() async {
    emit(DonationLoading());
    try {
      final cards = await UserService(ApiClient().dio).getUserDonation();
      emit(DonationLoaded(cards));
    } catch (e) {
      emit(DonationError("Xatolik yuz berdi: ${e.toString()}"));
    }
  }
}
