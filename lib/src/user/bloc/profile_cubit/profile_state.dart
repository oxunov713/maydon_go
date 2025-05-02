import '../../../common/model/main_model.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdating extends ProfileState {
  final UserModel user;
  final bool isStadiumCreated; // Stadion yaratilganligini ko'rsatadi
  const ProfileUpdating(this.user, {this.isStadiumCreated = false});
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
