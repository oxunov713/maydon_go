import 'package:equatable/equatable.dart';

import '../../../common/model/bank_card_model.dart';

abstract class DonationState extends Equatable {
  const DonationState();

  @override
  List<Object> get props => [];
}

class DonationInitial extends DonationState {}

class DonationLoading extends DonationState {}

class DonationLoaded extends DonationState {
  final List<BankCard> cards;

  const DonationLoaded(this.cards);

  @override
  List<Object> get props => [cards];
}

class DonationError extends DonationState {
  final String message;

  const DonationError(this.message);

  @override
  List<Object> get props => [message];
}
