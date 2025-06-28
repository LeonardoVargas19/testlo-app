import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:teslo_shop/features/auth/infrastruction/infrastruction.dart';
import 'package:teslo_shop/features/shared/infrastructions/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructions/services/key_value_storages_services_imp.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepositorie = AuthRepositorieImp();
  final keyValueStorageService = KeyValueStoragesServicesImp();

  return AuthNotifier(
      authRepository: authRepositorie,
      keyValueStorageService: keyValueStorageService);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email, password);
      _setLogUser(user);
    } on CustomErro catch (e) {
      logout(e.messages);
    } catch (e) {
      logout('Error ');
    }
  }

  void registerUser(String email, String password) async {}


  
  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLogUser(user);
    }catch (e) {
      logout();
    }
  }

  Future<void> logout([String? errorMessages]) async {
    await keyValueStorageService.removeKey('token');
    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessages: errorMessages);
  }

  void _setLogUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user);
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessages: '',
    );
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessages;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessages = ''});

  AuthState copyWith(
          {AuthStatus? authStatus, User? user, String? errorMessages}) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessages: errorMessages ?? this.errorMessages);
}
