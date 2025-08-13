import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_role.dart';

/// Provider for current user state
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<AppUser?>>((
  ref,
) {
  return UserNotifier();
});

/// Provider for user role specifically
final userRoleProvider = Provider<UserRole?>((ref) {
  final userAsync = ref.watch(userProvider);
  return userAsync.when(
    data: (user) => user?.role,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider to check if user is tenant
final isTenantProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.tenant;
});

/// Provider to check if user is owner
final isOwnerProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.owner;
});

class UserNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  UserNotifier() : super(const AsyncValue.loading()) {
    _loadUser();
  }

  static const String _userKey = 'app_user';
  static const String _userRoleKey = 'user_role';

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        // In a real app, you'd parse the JSON
        // For now, create a mock user based on stored role
        final roleString = prefs.getString(_userRoleKey) ?? 'tenant';
        final role = UserRole.fromString(roleString);

        final user = AppUser(
          id: '1',
          email: 'user@homevz.co.ke',
          fullName: 'John Doe',
          role: role,
          createdAt: DateTime.now(),
        );

        state = AsyncValue.data(user);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> setUserRole(UserRole role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userRoleKey, role.value);

      // Create or update user with new role
      final currentUser = state.value;
      final user =
          currentUser?.copyWith(role: role) ??
          AppUser(
            id: '1',
            email: 'user@homevz.co.ke',
            fullName: 'John Doe',
            role: role,
            createdAt: DateTime.now(),
          );

      await prefs.setString(_userKey, 'user_data'); // In real app, store JSON
      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateUser(AppUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, 'user_data'); // In real app, store JSON
      await prefs.setString(_userRoleKey, user.role.value);

      state = AsyncValue.data(user);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> signOut() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_userRoleKey);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
