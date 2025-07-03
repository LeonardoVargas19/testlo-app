import 'package:teslo_shop/config/const/environment.dart';
import 'package:teslo_shop/features/auth/infrastruction/mappers/user_mapper.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

class ProductMapper {
  static jsontoEntity(Map<String, dynamic> json) => Product(
      id: json['id'],
      title: json['title'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes'].map((size) => size)),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((tags) => tags)),
      images: List<String>.from(json['images'].map((String images) =>
          images.startsWith('http')
              ? images
              : '${Environment.apiUrl}/files/product/$images')),
      user: UserMapper.userJsonToEntity(json['user']) );
      
}
