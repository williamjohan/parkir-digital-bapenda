part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final String? photoPath;
  ProfileLoaded(this.user, {this.photoPath});
}

class ProfileRefreshError extends ProfileState {
  final UserEntity oldUser;
  final String message;
  final String? oldPhotoPath;

  ProfileRefreshError(this.oldUser, this.message, {this.oldPhotoPath});
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}
