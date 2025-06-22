

import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class UserMapper {

  static User userJsonToEntity(Map <String,dynamic> json )=>User(
   id:json['id'],
   name:json['name'],
   fullName:json['fullname'] ,
   roles:List<String>.from( json['roles'].map((role)=>role)) ,
   token:json['token'] ,
);

  

}