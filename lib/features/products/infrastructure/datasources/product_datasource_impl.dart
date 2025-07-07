import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domian.dart';
import 'package:teslo_shop/features/products/infrastructure/errors/product_errors.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductDatasourceImpl extends ProductsDatasources {
  late final Dio dio;
  final String accesToken;
  ProductDatasourceImpl({required this.accesToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accesToken'}));

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('products/$id');
      final product = ProductMapper.jsontoEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPages(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('products?limit=$limit&offset=$offset');

    final List<Product> products = [];

    for (var item in response.data ?? []) {
      products.add(ProductMapper.jsontoEntity(item));
    }

    return products;
  }
}
