
import '../../../common/model/main_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdating extends ProfileState {
  final UserModel user;
  const ProfileUpdating(this.user);
}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  const ProfileLoaded(this.user);
}

class ProfileError extends ProfileState {
  final String message;
  final UserModel? lastUser;
  const ProfileError(this.message, [this.lastUser]);
}