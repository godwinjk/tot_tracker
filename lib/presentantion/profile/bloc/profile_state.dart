part of 'profile_cubit.dart';

final class ProfileState {
  final String appVersion;
  final String babyName;
  final String gender;
  final DateTime? dueDate;

  const ProfileState(
      {required this.appVersion,
      required this.babyName,
      required this.gender,
      required this.dueDate});

  ProfileState copyWith({
    String? babyName,
    DateTime? dueDate,
    String? gender,
    String? appVersion,
  }) {
    return ProfileState(
      babyName: babyName ?? this.babyName,
      dueDate: dueDate ?? this.dueDate,
      gender: gender ?? this.gender,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}
