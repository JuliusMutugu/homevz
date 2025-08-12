import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserType { tenant, landlord }

class UserTypeState {
  final UserType userType;
  final bool isLoggedIn;

  UserTypeState({
    required this.userType,
    this.isLoggedIn = false,
  });

  UserTypeState copyWith({
    UserType? userType,
    bool? isLoggedIn,
  }) {
    return UserTypeState(
      userType: userType ?? this.userType,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

class UserTypeNotifier extends StateNotifier<UserTypeState> {
  UserTypeNotifier() : super(UserTypeState(userType: UserType.tenant));

  void setUserType(UserType userType) {
    state = state.copyWith(userType: userType);
  }

  void login() {
    state = state.copyWith(isLoggedIn: true);
  }

  void logout() {
    state = state.copyWith(isLoggedIn: false);
  }

  bool get isTenant => state.userType == UserType.tenant;
  bool get isLandlord => state.userType == UserType.landlord;
}

final userTypeProvider = StateNotifierProvider<UserTypeNotifier, UserTypeState>((ref) {
  return UserTypeNotifier();
});
