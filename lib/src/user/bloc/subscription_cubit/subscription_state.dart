part of 'subscription_cubit.dart';

abstract class SubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<SubscriptionModel> subscriptions;
  final int selectedIndex;

  SubscriptionLoaded(this.subscriptions, {this.selectedIndex = 0});

  @override
  List<Object?> get props => [subscriptions, selectedIndex];
}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError(this.message);

  @override
  List<Object?> get props => [message];
}
