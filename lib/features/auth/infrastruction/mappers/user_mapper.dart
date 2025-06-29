import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class UserMapper {
static User userJsonToEntity(Map<String, dynamic> json) => User(
  id: json['id'],
  email: json['email'], // o json['name'] si existe ese campo
  fullName: json['fullName'], // ✅ corregido: 'fullName' bien escrito
  roles: List<String>.from(json['roles'].map((role) => role)),
  token: json['token'],
);

}
