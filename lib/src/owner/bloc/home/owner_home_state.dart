import 'package:equatable/equatable.dart';
import 'package:maydon_go/src/common/model/main_model.dart';

abstract class OwnerHomeState extends Equatable {
  final int selectedIndex;

  const OwnerHomeState({this.selectedIndex = 1});

  @override
  List<Object> get props => [selectedIndex];
}

class OwnerHomeIntial extends OwnerHomeState {}

class OwnerHomeLoading extends OwnerHomeState {
  const OwnerHomeLoading({super.selectedIndex});
}

class OwnerHomeLoadedState extends OwnerHomeState {
  final List<SubscriptionModel> subscriptions;

  const OwnerHomeLoadedState(this.subscriptions, {super.selectedIndex});

  @override
  List<Object> get props => [subscriptions, selectedIndex];
}

class OwnerHomeError extends OwnerHomeState {
  final String message;

  const OwnerHomeError(this.message, {super.selectedIndex});

  @override
  List<Object> get props => [message, selectedIndex];
}