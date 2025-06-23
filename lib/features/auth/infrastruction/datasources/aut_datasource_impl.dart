import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infrastruction/infrastruction.dart';

import '../../domain/domain.dart';

class AuthDataSourceImplement extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('auth/login', data: {'email': email, 'password': password});
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      print(e);
      if (e.response?.statusCode == 401) throw WrongCredentials();
      if (e.type == DioException.connectionTimeout) {
        throw CustomErro('Revisar conexion a internet',1);
      }

      throw CustomErro('Somthing wrong Happend', 1);
    } catch (e) {
      throw CustomErro('Somthing wrong Happend', 1);
    }
  }

  @override
  Future<User> register(String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
