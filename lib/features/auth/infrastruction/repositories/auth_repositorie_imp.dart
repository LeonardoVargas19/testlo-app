import 'package:teslo_shop/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:teslo_shop/features/auth/infrastruction/infrastruction.dart';
import '../../domain/domain.dart';

class AuthRepositorieImp extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositorieImp(
    AuthDatasource? datasource
  ):datasource= datasource ?? AuthDataSourceImplement();


  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
   return datasource.login(email, password);
  }

  @override
  Future<User> register(String email, String password) {
    return register(email, password);
  }
}