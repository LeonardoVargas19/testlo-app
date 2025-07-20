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

    Future<String> _uploadFile ( String path)async{
      try {
        final fileName = path.split('/').last;
        final FormData data = FormData.fromMap({
          'file':MultipartFile.fromFileSync(path,filename: fileName),
          
        });
        final response = await dio.post('/file/product',data: data);
        return response.data['image'];


      } catch (e) {
        throw Exception();
        
      }
    }


  Future<List<String>> _uploadPhotos (List<String> photos )async {
    final photosUpdate = photos.where((element)=>element.contains('/')).toList();
    final ignorePhotos = photos.where((element)=>!element.contains('/')).toList();

    final List<Future<String>> uploadJob = photosUpdate.map((e)=> _uploadFile(e)).toList();
    final newImages = await Future.wait(uploadJob);
    return [...ignorePhotos,...newImages];
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) async {
    try {
      final String? producId = productLike['id'];
      final String method = (producId == null) ? 'POST' : 'PATCH';
      final String url = (producId == null) ? '/products' : '/products/$producId';

      productLike.remove('id');
      productLike['images'] = await _uploadPhotos( productLike['images']);

      final response = await dio.request(url,
          data: productLike, options: Options(method: method));
      final product = ProductMapper.jsontoEntity(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
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
