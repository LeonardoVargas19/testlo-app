

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domian.dart';

class ProductDatasourceImpl extends ProductsDatasources{
  
  late final Dio dio;
  final String accesToken;
  ProductDatasourceImpl({
    required this.accesToken
  }):dio= Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      headers: {
        'Authorization':'Bearer $accesToken'
      }
    )
  );

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) {
   // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPages({int limit = 10, int offset = 0}) async{
   final response = await dio.get<List>('/api/products?limit=$limit&offset=$offset');
   final List<Product> products = [];
   for (var products in response.data ?? []) {
      // products.add(); TODO crear un mapper 
  
   }
   return products;
  

  }
}