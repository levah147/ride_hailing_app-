import '../../../../core/network/api_service.dart';
import '../../domain/models/user.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  /// Logs in the user using phone number and password
  Future<User> login(String phoneNumber, String password) async {
    try {
      await _apiService.login(phoneNumber, password);
      final userData = await _apiService.getCurrentUser();
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  /// Registers a new user and logs them in immediately after
  Future<User> register(
    String phoneNumber,
    String password,
    String firstName,
    String lastName,
    String email,
  ) async {
    try {
      final userData = {
        'phone_number': phoneNumber,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'username': phoneNumber, // Use phone number as username
        'role': 'rider', // Default user role
      };

      await _apiService.register(userData);
      return await login(phoneNumber, password);
    } catch (e) {
      rethrow;
    }
  }

  /// Logs the user out
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches the currently authenticated user
  Future<User> getCurrentUser() async {
    try {
      final userData = await _apiService.getCurrentUser();
      return User.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  /// Updates user information and returns the updated user
  Future<User> updateUser(Map<String, dynamic> userData) async {
    try {
      final updatedUserData = await _apiService.updateUser(userData);
      return User.fromJson(updatedUserData);
    } catch (e) {
      rethrow;
    }
  }
}
