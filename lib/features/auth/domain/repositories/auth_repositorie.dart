import '../domain.dart' show User;

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password);
  Future<User> checkAuthStatus(String token);
}
