import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductRepositories {
  Future<List<Product>> getProductsByPages({int limit = 10, int offset = 0});

  Future<Product> getProductById(String id);

  Future<Product> createProduct(Map<String, dynamic> productLike);
}
