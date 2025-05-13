import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:maydon_go/src/common/service/api/api_client.dart';
import 'package:maydon_go/src/common/service/api/api_image_service.dart';
import 'package:maydon_go/src/common/service/api/user_service.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial()) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    emit(ProfileLoading());
    try {
      final user = await UserService(ApiClient().dio).getUser();
      Logger().d(user.point);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError('Failed to load user data'));
    }
  }

  Future<void> updateProfileImage(File imageFile) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    // Immediately show the selected image while uploading
    emit(
      ProfileUpdating(
        currentState.user.copyWith(imageUrl: imageFile.path),
      ),
    );

    try {
      // Upload to server
      final imageUrl =
          await ApiImageService(ApiClient().dio).uploadProfileImage(imageFile);

      // Update with server response
      emit(ProfileLoaded(
        currentState.user.copyWith(imageUrl: imageUrl),
      ));
    } catch (e) {
      // Revert to previous state if error occurs
      emit(ProfileError('Failed to update profile image', currentState.user));
      rethrow;
    }
  }

  Future<void> updateUserName(String newName) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(ProfileUpdating(currentState.user));

    try {
      final updatedUser =
          await UserService(ApiClient().dio).updateUserInfo(name: newName);

      emit(ProfileLoaded(updatedUser));
    } catch (e) {
      emit(ProfileError('Failed to update name', currentState.user));
      rethrow;
    }
  }
}
