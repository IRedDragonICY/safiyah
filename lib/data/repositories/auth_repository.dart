import '../models/user_model.dart';
import '../datasources/local/local_storage.dart';

class AuthRepository {
  final LocalStorage _localStorage = LocalStorage();

  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = await _localStorage.getCurrentUser();
      if (userData != null) {
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For prototype, always return dummy user
    final user = _getDummyUser();
    await _localStorage.saveCurrentUser(user.toJson());
    return user;
  }

  Future<UserModel> signUp(String email, String password, String fullName) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));
    
    // For prototype, create dummy user
    final user = _getDummyUser().copyWith(
      email: email,
      fullName: fullName,
    );
    await _localStorage.saveCurrentUser(user.toJson());
    return user;
  }

  Future<void> signOut() async {
    await _localStorage.clearCurrentUser();
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _localStorage.saveCurrentUser(user.toJson());
  }

  UserModel _getDummyUser() {
    return UserModel(
      id: 'user123',
      email: 'muslim.traveler@safiyah.com',
      fullName: 'Ahmad Muslim',
      profileImageUrl: 'https://example.com/profile.jpg',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
      preferences: const UserPreferences(
        enablePrayerNotifications: true,
        enableLocationTracking: true,
        madhab: 'Shafi',
        calculationMethod: 'MWL',
        prayerNotificationMinutes: 15,
        darkMode: false,
        language: 'en',
      ),
    );
  }
}