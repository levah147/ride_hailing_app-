import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ride_hailing_app/core/network/api_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user.dart';

// Simple state notifier instead of code-generated riverpod
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;
  
  AuthNotifier(this._repository) : super(const AsyncValue.loading()) {
    _initialize();
  }
  
  Future<void> _initialize() async {
    try {
      final user = await _repository.getCurrentUser();
      state = AsyncValue.data(user);
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }
  
  Future<void> login(String phoneNumber, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(phoneNumber, password);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> register(String phoneNumber, String password, String firstName, String lastName, String email) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.register(phoneNumber, password, firstName, lastName, email);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logout();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> updateUser(Map<String, dynamic> userData) async {
    try {
      final user = await _repository.updateUser(userData);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

// Create providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService);
});

final apiServiceProvider = Provider((ref) => ApiService());

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return AuthRepository(apiService);
// });
