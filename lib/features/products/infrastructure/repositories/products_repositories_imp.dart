import 'package:teslo_shop/features/products/domain/domian.dart';

class ProductsRepositoriesImp extends ProductRepositories {
  final ProductsDatasources datasources;

  ProductsRepositoriesImp(this.datasources);

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) {
    return datasources.createProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return datasources.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPages({int limit = 10, int offset = 0}) {
    return datasources.getProductsByPages(limit: limit, offset: offset);
  }
}
