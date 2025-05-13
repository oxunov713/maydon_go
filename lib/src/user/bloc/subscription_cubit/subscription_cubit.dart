import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../common/model/main_model.dart';
import '../../../common/service/api/api_client.dart';
import '../../../common/service/api/user_service.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial());

  Future<void> fetchSubscriptions() async {
    emit(SubscriptionLoading());
    try {
      final subscriptions = await UserService(ApiClient().dio).getClientSubscription();
      emit(SubscriptionLoaded(subscriptions));
    } catch (e) {
      emit(SubscriptionError("Xatolik: ${e.toString()}"));
    }
  }

  void selectSubscription(int index) {
    if (state is SubscriptionLoaded) {
      final currentState = state as SubscriptionLoaded;
      emit(
          SubscriptionLoaded(currentState.subscriptions, selectedIndex: index));
    }
  }
}
